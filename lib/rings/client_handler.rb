require 'rings/command_handlers/greet_command_handler'
require 'rings/command_handlers/join_command_handler'

module Rings
  class ClientHandler
    attr_reader :server, :client_socket

    UnknownCommandError = Class.new(RuntimeError)

    def initialize(server, client_socket)
      @server, @client_socket = server, client_socket
      server.with_connected_socket(client_socket) do
        parse_line do |command, args|
          handle_incoming_command command, args
        end
      end
    end

    private

    def parse_line &block
      until client_socket.eof?
        args = client_socket.gets.split(/\s+/)
        command = args.shift
        block.call command, args
      end
    end

    def handle_incoming_command command, args
      case command
      when CommandHandlers::GreetCommandHandler.command
        CommandHandlers::GreetCommandHandler.new(self, *args)
      when CommandHandlers::JoinCommandHandler.command
        CommandHandlers::JoinCommandHandler.new(self, *args)
      else
        raise UnknownCommandError, "Command not supported: #{command} #{args.inspect}"
      end
    end

  end
end