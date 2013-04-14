require 'uri'

require 'rings/command_handling'
require 'rings/command_handler'

module Rings
  module CommandHandlers
    class SendMessageCommandHandler < CommandHandler
      include CommandHandling
      has_arguments message: :string

      def initialize(session, *args)
        super session
        parse_arguments args
      end

      def self.command
        'send_message'
      end

      def handle_command
        if @session.send_message
          recipients = client_socket.game.each_player.select(&:chat_supported?)
          recipients.each do |recipient|
            recipient.send_command :add_message, client_socket.nickname, arguments(:message)
          end
        end
      end
    end
  end
end