require 'rings/game'
require 'rings/piece'
require 'rings/pieces_factory'

module Rings
  module Games
    class TwoPlayerGame < Game
      def initialize x, y, first_player, second_player
        super(x, y, [first_player, second_player])
      end

      private

      def assign_arsenal_to_players        
        @players[0].arsenal = [
          *PiecesFactory.create_arsenal(Piece::ALLOWED_COLORS[0]),
          *PiecesFactory.create_arsenal(Piece::ALLOWED_COLORS[1]),
        ]

        @players[1].arsenal = [
          *PiecesFactory.create_arsenal(Piece::ALLOWED_COLORS[2]),
          *PiecesFactory.create_arsenal(Piece::ALLOWED_COLORS[3]),
        ]
      end
    end

    def find_player_for_color color
      case color
      when Piece::ALLOWED_COLORS[0], Piece::ALLOWED_COLORS[1]
        @players[0]
      when Piece::ALLOWED_COLORS[2], Piece::ALLOWED_COLORS[3]
        @players[1]
      end
    end
  end
end
