module Rings
  class Game
    attr_reader :players, :board

    MIN_PLAYERS = 2
    MAX_PLAYERS = 4

    def initialize players, board
      @players = players
      @board = board
      place_starting_pieces
    end

    private

    def place_starting_pieces
      @board.place_starting_pieces [1, 2, 3].sample, [1, 2, 3].sample
    end
  end
end