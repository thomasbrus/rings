require 'rings/game'

module Rings
  module Games
    class ThreePlayerGame < Game
      def initialize x, y, first_player, second_player, third_player
        super(x, y, [first_player, second_player, third_player])
      end

      private

      def assign_arsenal_to_players
        shared_color = Piece::ALLOWED_COLORS[3]        
        Piece::ALLOWED_COLORS[0..2].each_with_index do |color, index|
          @players[index].arsenal = PiecesFactory.create_arsenal(color, shared_color)
        end
      end

      def find_player_for_color color
        case color
        when Piece::ALLOWED_COLORS[0]
          @players[0]
        when Piece::ALLOWED_COLORS[1]
          @players[1]
        when Piece::ALLOWED_COLORS[2]
          @players[2]
        end
      end      
    end
  end
end
