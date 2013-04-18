require 'rings/games/two_player_game'
require 'rings/games/three_player_game'
require 'rings/games/four_player_game'

module Rings
  module GamesFactory
    def create x, y, players
      case players.count
      when 2
        TwoPlayerGame.new(x, y, *players)
      when 3
        ThreePlayerGame.new(x, y, *players)
      when 4
        FourPlayerGame.new(x, y, *players)
      else
        raise ArgumentError, "Invalid number of players, must be between 2 and 4."
      end
    end

    module_function :create
  end
end
