require 'rings/command_handling'
require 'rings/command_handler'

module Rings
  module CommandHandlers
    class GreetCommandHandler < CommandHandler
      include CommandHandling
      has_arguments name: :username, chat_supported?: :switch, challenge_supported?: :switch

      def self.command
        'greet'
      end

      def handle_command *args
        args = parse_arguments *args

        if server.name_taken? args[:name]
          return client_socket.puts %Q[error "Name '#{args[:name]}' is already taken."]
        end
        
        client_socket.name = args[:name]
        client_socket.chat_supported = args[:chat_supported?]
        client_socket.challenge_supported = args[:challenge_supported?]

        client_socket.puts "#{self.class.command} #{server.chat_supported? ? 1 : 0} #{server.challenge_supported? ? 1 : 0}"
      end
    end
  end
end