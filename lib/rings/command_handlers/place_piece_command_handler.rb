require 'rings/command_handling'
require 'rings/command_handler'

require 'state_machine/core'

module Rings
  module CommandHandlers
    class PlacePieceCommandHandler < CommandHandler
      include CommandHandling
      has_arguments type: :string, color: :string, x: :integer, y: :integer
      
      def initialize(session, *args)
        super session
        parse_arguments args
      end

      def self.command
        'place_piece'
      end

      def handle_command
        if @session.can_place_piece?
          @session.place_piece!

          begin
            piece = PiecesFactory.create(arguments(:type), arguments(:color))
            client_socket.take_turn(piece, arguments(:x), arguments(:y))
          rescue ArgumentError => e
            raise CommandError, e.message
          end
          
          args = [arguments(:type), arguments(:color), arguments(:x), arguments(:y)]
          notify_all_players(:place_piece, args)

          if client_socket.game.over?
            @session.end_game!
            notify_all_players(:game_over, *client_socket.game.winners.map(&:nickname))
          end
        else
          message = "Place piece command not allowed. "
          message << "It's only allowed to place pieces while in game."
          client_socket.send_command(:error, message)
        end
      end

      private

      def notify_all_players command, args
        client_socket.game.each_player do |player|
          player.send_command(command, *args)
        end
      end
    end
  end
end
