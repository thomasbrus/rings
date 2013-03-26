require 'rings/command_handling'
require 'rings/command_handler'

module Rings
  module CommandHandlers
    class GreetCommandHandler < CommandHandler
      extend CommandHandling
      has_arguments name: :username, chat_supported?: :switch, challenge_supported?: :switch

      def self.command
        'greet'
      end

      def handle_command
        if server.name_taken? name
          client_socket.puts %Q{error "Name '#{name}' is already taken."} and return
        end
        
        client_socket.name = name
        client_socket.chat_supported = chat_supported?
        client_socket.challenge_supported = challenge_supported?

        client_socket.puts "#{self.class.command} #{server.chat_supported? ? 1 : 0} #{server.challenge_supported? ? 1 : 0}"
      end
    end
  end
end