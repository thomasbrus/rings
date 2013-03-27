require 'rings/command_handling'
require 'rings/command_handlers/greet_command_handler'
require 'rings/command_handlers/join_command_handler'
# require 'rings/command_handlers/place_command_handler'

module Rings
  class ClientHandler
    attr_reader :server, :client_socket  

    def initialize(server, client_socket)
      @server, @client_socket = server, client_socket
      server.with_connected_socket(client_socket) do
        parse_lines do |command, args|          
          begin
            handle_incoming_command command, args
          rescue CommandHandling::CommandError => e
            client_socket.puts %Q[error "#{e.message}"]
            server.puts %Q[Error occured: "#{e.message}"]
          end
        end
      end
    end

    private

    def parse_lines &block
      # TODO: Use #each_line ?
      until client_socket.eof?
        args = client_socket.gets.split(/\s+/)
        command = args.shift
        block.call command, args
      end
    end

    def handle_incoming_command command, args
      case command
      when CommandHandlers::GreetCommandHandler.command
        CommandHandlers::GreetCommandHandler.new(self).handle_command(*args)
      when CommandHandlers::JoinCommandHandler.command
        CommandHandlers::JoinCommandHandler.new(self).handle_command(*args)
      # when CommandHandlers::PlaceCommandHandler.command
      #   CommandHandlers::PlaceCommandHandler.new(self).handle_command(*args)
      else
        raise CommandHandling::CommandError, "Command not supported: #{command} #{args.inspect}"
      end
    end

  end
end