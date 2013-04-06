require 'rings/command_handling'
require 'rings/command_handler'

module Rings
  module CommandHandlers
    class PlaceRingCommandHandler < CommandHandler
      include CommandHandling
      has_arguments kind: :string, color: :string, x: :integer, y: :integer
      
      def initialize(session, *args)
        super session
        parse_arguments *args
      end

      def self.command
        'place_piece'
      end      

      def handle_command
        # TODO: handle invalid kind, color, x or y

        if @session.place_piece
          x, y = arguments(:x), arguments(:y)
          kind, color = arguments(:kind), arguments(:color)
          client_socket.game.place_piece kind, color, x, y
        end
      end
    end
  end
end
