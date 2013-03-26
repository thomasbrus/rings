require 'rings/command_handlers/greet_command_handler'
require 'rings/command_handlers/join_command_handler'

module Rings
  class ClientHandler
    attr_reader :server, :client

    def initialize(server, client)
      @server, @client = server, client
      server.with_connected_socket(client) do
        parse_line do |command, args|
          handle_incoming_command command, args
        end
      end
    end

    private

    def parse_line &block
      until client.eof?
        args = client.gets.split(/\s+/)
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
        raise "Command not supported: #{args.inspect}" if args.count > 1
      end
    end

  end
end