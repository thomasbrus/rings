require 'uri' 
require 'rings/command_handling'
require 'rings/command_handler'

module Rings
  module CommandHandlers
    class JoinServerCommandHandler < CommandHandler
      include CommandHandling
      has_arguments nickname: :string, chat_supported?: :boolean, challenge_supported?: :boolean

      def initialize(session, *args)
        super session
        parse_arguments args
      end

      def self.command
        'join_server'
      end

      def handle_command
        if server.nickname_taken? arguments(:nickname)
          raise CommandError, %Q[Nickname "#{nickname} is already taken."]
        end

        if @session.join
          client_socket.nickname = arguments(:nickname)
          client_socket.chat_supported = arguments(:chat_supported?)
          client_socket.challenge_supported = arguments(:challenge_supported?)

          send_chat_support_notification server.chat_supported?
          send_challenge_support_notification server.challenge_supported?  
        end
      end      

      private

      def send_chat_supported_notification chat_supported
        client_socket.send_command :notify_chat_support, chat_supported ? 1 : 0
      end

      def send_challenge_support_notification challenge_supported
        client_socket.send_command :notify_challenge_support, challenge_supported ? 1 : 0
      end
    end
  end
end
