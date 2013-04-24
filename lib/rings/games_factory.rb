require 'rings/games/two_player_game'
require 'rings/games/three_player_game'
require 'rings/games/four_player_game'

module Rings
  module GamesFactory
    def self.create x, y, players
      case players.count
      when 2; Games::TwoPlayerGame.new(x, y, *players)
      when 3; Games::ThreePlayerGame.new(x, y, *players)
      when 4; Games::FourPlayerGame.new(x, y, *players)
      else raise ArgumentError, "Invalid number of players, must be between 2 and 4."
      end
    end
  end
end
