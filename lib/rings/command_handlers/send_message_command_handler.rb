require 'uri'

require 'rings/command_handling'
require 'rings/command_handler'

require 'state_machine/core'

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
        if @session.can_send_message?
          @session.send_message!

          recipients = client_socket.game.each_player.select(&:chat_supported?)

          recipients.each do |recipient|
            recipient.send_command(:add_message, client_socket.nickname, arguments(:message))
          end
        else
          message = "Chat command not allowed. "
          message << "It's only allowed to send chat messages while in game."
          client_socket.send_command(:error, message)
        end
      end
    end
  end
end