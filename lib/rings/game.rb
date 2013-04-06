require 'rings/board'

module Rings
  class Game
    attr_reader :players

    MIN_PLAYERS = 2
    MAX_PLAYERS = 4

    def initialize players
      @board = Board.new
      @players = players
    end

    def place_piece kind, color, x, y      
      @board.place Piece.create(kind, color), x, y
    end

    def place_starting_pieces
      x, y = [1, 2, 3].sample, [1, 2, 3].sample 
      @board.place_starting_pieces x, y
      [x, y]
    end
  end
end