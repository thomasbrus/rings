require 'rings/command_handling'
require 'rings/command_handler'
require 'rings/waiting_queue'

module Rings
  module CommandHandlers
    class PlaceCommandHandler < CommandHandler
      include CommandHandling
      has_arguments piece: :string, x: :integer, y: :integer
      
      # include Protocol
      # requires_presence_of :nickname, :chat_supported, :challenge_supported
      # requires :in_game?

      def self.command
        'place'
      end      

      def handle_command *args
        args = parse_arguments *args
      end
    end
  end
end