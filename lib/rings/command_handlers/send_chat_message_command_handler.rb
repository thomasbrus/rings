require 'uri'

require 'rings/command_handling'
require 'rings/command_handler'

module Rings
  module CommandHandlers
    class ChatCommandHandler < CommandHandler
      include CommandHandling
      has_arguments message: :string

      def initialize(session, *args)
        super session
        parse_arguments *args
      end

      def self.command
        'send_chat_message'
      end

      def handle_command
        if @session.send_chat_message
          recipients = client_socket.game.players - [client_socket]
          recipients.select(&:chat_supported?).each do |recipient|
            recipient.send_command :add_message, arguments(:message)
          end
        end
      end
    end
  end
end