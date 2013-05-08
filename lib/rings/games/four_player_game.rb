require 'rings/game'

module Rings
  module Games
    class FourPlayerGame < Game
      def initialize x, y, first_player, second_player, third_player, fourth_player
        super(x, y, [first_player, second_player, third_player, fourth_player])
      end

      private

      def assign_arsenal_to_players        
        Piece::ALLOWED_COLORS.each_with_index do |color, index|
          @players[index].arsenal = PiecesFactory.create_arsenal(color)          
        end
      end

      def find_player_by_color color
        @players[Piece::ALLOWED_COLORS.index(color)]
      end
    end
  end
end
