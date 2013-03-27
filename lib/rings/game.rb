require 'rings/board'

module Rings
  class Game
    attr_reader :players

    MIN_PLAYERS = 2
    MAX_PLAYERS = 4

    def initialize players
      @board = Board.new
      @players = players
      place_starting_pieces
    end

    def place_starting_pieces
      @board.place_starting_pieces [1, 2, 3].sample, [1, 2, 3].sample
    end
  end
end