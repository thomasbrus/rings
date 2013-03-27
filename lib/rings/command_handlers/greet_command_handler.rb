require 'rings/command_handling'
require 'rings/command_handler'

module Rings
  module CommandHandlers
    class GreetCommandHandler < CommandHandler
      include CommandHandling
      has_arguments nickname: :string, chat_supported?: :boolean, challenge_supported?: :boolean

      def self.command
        'greet'
      end

      def handle_command *args
        args = parse_arguments *args

        if server.nickname_taken? args[:nickname]
          return client_socket.puts %Q[error "Name '#{args[:nickname]}' is already taken."]
        end
        
        client_socket.nickname = args[:nickname]
        client_socket.chat_supported = args[:chat_supported?]
        client_socket.challenge_supported = args[:challenge_supported?]

        client_socket.puts "#{self.class.command} #{server.chat_supported? ? 1 : 0} #{server.challenge_supported? ? 1 : 0}"
      end
    end
  end
end