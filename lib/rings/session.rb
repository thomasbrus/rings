require 'rings/command_handling'
require 'rings/command_handlers/join_server_command_handler'
require 'rings/command_handlers/request_game_command_handler'
require 'rings/command_handlers/place_piece_command_handler'
require 'rings/command_handlers/send_message_command_handler'

require 'state_machine/core'

module Rings
  class Session
    attr_reader :server, :client_socket
    extend StateMachine::MacroMethods

    state_machine initial: :connected do
      event :join_server do
        transition :connected => :joined_server
      end

      event :request_game do
        transition :joined_server => :joined_server
      end

      event :start_game do
        transition :joined_server => :in_game
      end

      event :send_message do
        transition :in_game => :in_game
      end

      event :place_piece do
        transition :in_game => :in_game
      end

      event :end_game do
        transition :in_game => :joined_server
      end

      after_transition on: :join_server do |session|
        message = "#{session.client_socket.inspect} joined the server"
        message << session.client_socket.nickname.to_s
        session.server.logger.info message.bold
      end

      [:join_server, :send_message, :place_piece, :request_game].each do |command|
        after_failure on: command do |session|
          message = "Failed to issue the #{command} command"
          session.server.logger.warn message
        end
      end
    end

    def initialize(server, client_socket)
      @server = server
      @client_socket = client_socket

      initialize_state_machines
      
      server.with_connected_socket(client_socket) do
        begin
          while line = client_socket.gets
            parse_line(line)
          end
        rescue Errno::ECONNRESET => e
          server.logger.error e.message
        ensure
          server.logger.info "#{client_socket.inspect} disconnected"
        end
      end      
    end

    private

    def parse_line line
      args = line.chomp.split(/\s+/)
      command = args.shift
      handle_incoming_command command, args
    rescue CommandHandling::CommandError => e
      client_socket.send_command :error, e.message
      server.logger.warn "Could not handle command. #{e.message}"
    end

    def command_handlers
      [ CommandHandlers::JoinServerCommandHandler,
        CommandHandlers::RequestGameCommandHandler,
        CommandHandlers::PlacePieceCommandHandler,
        CommandHandlers::SendMessageCommandHandler ]
    end

    def handle_incoming_command command, arguments
      fail = ->{ raise CommandHandling::CommandError, "Unknown command: #{command}" }
      
      command_handler_klass = command_handlers.find(fail) do |command_handler_klass|
        command_handler_klass.command == command
      end

      server.logger.info "Received command: #{command} with arguments: #{arguments.inspect}"
      command_handler_klass.new(self, *arguments).handle_command
    end
  end
end
