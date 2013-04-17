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
    end

    def initialize(server, client_socket)
      @server = server
      @client_socket = client_socket

      initialize_state_machines
      
      server.with_connected_socket(client_socket) do
        until client_socket.eof?
          parse_line client_socket.gets
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
      server.puts %Q[Error occured while handling command. #{e.message}]
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

      command_handler_klass.new(self, *arguments).handle_command
    end
  end
end