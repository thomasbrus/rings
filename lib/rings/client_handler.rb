module Rings
  class ClientHandler
    attr_reader :server, :client

    def initialize(server, client)
      @server = server
      @client = client
      server.add_socket @client
      handle_incoming_commands
      server.remove_socket @client
    end

    private

    def handle_incoming_commands
      until client.eof?
        args = client.gets.split(/\s+/)
        case args.shift
        when Rings::CommandHandlers::GreetCommandHandler.command
          Rings::CommandHandlers::GreetCommandHandler.new(self, *args)
        when Rings::CommandHandlers::JoinCommandHandler.command
          Rings::CommandHandlers::JoinCommandHandler.new(self, *args)
        else
          raise "Command not supported."
        end
      end
    end

  end
end