module Rings
  class Game
    attr_reader :players, :board

    def initialize players, board
      @players = players
      @board = board
      place_starting_pieces
    end

    private

    def place_starting_pieces
      @board.place_starting_pieces [2, 3, 4].sample, [2, 3, 4].sample
    end
  end
end