require 'rings/game'

module Rings
  module Games
    class ThreePlayerGame < Game
      def initialize(x, y, first_player, second_player, third_player)
        super(x, y, [first_player, second_player, third_player])
      end

      private

      def assign_arsenal_to_players
        Piece::ALLOWED_COLORS[0..2].each_with_index do |color, index|
          arsenal = PiecesFactory.create_shared_arsenal(color, Piece::ALLOWED_COLORS[3])
          @players[index].arsenal = arsenal          
        end
      end

      def find_player_by_color(color)
        case color
        when Piece::ALLOWED_COLORS[0]; @players[0]
        when Piece::ALLOWED_COLORS[1]; @players[1]
        when Piece::ALLOWED_COLORS[2]; @players[2]
        end
      end
    end
  end
end
