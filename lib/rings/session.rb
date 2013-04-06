require 'rings/command_handling'
require 'rings/command_handlers/greet_command_handler'
require 'rings/command_handlers/join_command_handler'
require 'rings/command_handlers/place_command_handler'
require 'rings/command_handlers/chat_command_handler'

require 'state_machine/core'

module Rings
  class Session
    attr_reader :server, :client_socket
    extend StateMachine::MacroMethods

    state_machine :state, initial: :connected do
      after_failure(on: :join_server, unless: :connected?) do |session|
        message = "Join command not allowed. "
        message << "It's not allowed to join twice."
        session.client_socket.send_command :error, message
      end

      after_failure(on: :request_game, unless: :joined_server?) do |session|
        message = "Request game command not allowed. "
        message << "It's not allowed to request a game before joining the server or when already in game."
        session.client_socket.send_command :error, message
        throw :halt
      end

      after_failure(on: :send_chat_message, unless: :in_game?) do |session|
        message = "Chat command not allowed. "
        message << "It's only allowed to send chat messages while in game."
        session.client_socket.send_command :error, message
      end

      after_failure(on: :place_piece, unless: :in_game?) do |session|
        message = "Place command not allowed. "
        message << "It's only allowed to place rings while in game."
        session.client_socket.send_command :error, message
      end

      event :join_server do
        transition :connected => :joined_server
      end

      event :request_game do
        transition :joined_server => :joined_server
      end

      event :start_game do
        transition :joined_server => :in_game
      end

      event :send_chat_message do
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

      server.with_connected_client(client_socket) do
        client_socket.each_line(&:parse_line)
      end

      initialize_state_machines
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
      [ CommandHandlers::JoinServerCommandHandler
      , CommandHandlers::RequestGameCommandHandler
      , CommandHandlers::PlaceRingCommandHandler
      , CommandHandlers::SendChatMessageCommandHandler ]
    end

    def handle_incoming_command command, arguments
      fail = ->{ raise CommandHandling::CommandError, "Unknown command: #{command}" }
      
      command_handler_klass = command_handlers.find(fail) do |chk|
        chk.command == command
      end

      command_handler_klass.new(self, *arguments).handle_command
    end
  end
end