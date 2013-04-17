require 'forwardable'

require 'rings/board'

module Rings
  class Game
    extend Forwardable
    def_delegators :@items, :each
    def_delegator :@players, :count, :player_count
    def_delegator :@players, :each, :each_player

    MIN_PLAYERS = 2
    MAX_PLAYERS = 4

    def initialize x, y, players
      @board = Board.new
      @players = players
      @current_turn = 0
      place_starting_pieces(x, y)
    end

    def current_player
      @players[@current_turn]
    end

    def take_turn player, piece, x, y
      raise ArgumentError, "It's not your turn!" unless player == current_player
      # raise SomeError, "The game is over" if over?
      
      unless can_place_piece?(piece, x, y)
        raise ArgumentError, "Cannot place this piece here."
      end

      @board.place(piece, x, y)

      @current_turn = (@current_turn + 1) % @players.size
    end

    def over?
      # ...
    end

    def winners
      # ...
    end

    private
    
    def place_starting_pieces x, y
      # TODO: raise if invalid coordinates !?
      @board.place LargeRingPiece.new(:purple), x, y
      @board.place MediumRingPiece.new(:yellow), x, y
      @board.place SmallRingPiece.new(:green), x, y
      @board.place ExtraSmallSolidPiece.new(:red), x, y
    end

    def can_place_piece? piece, x, y
      if piece.solid? && @board.has_adjacent_solid_piece_of_color?(piece.color, x, y)
        return false
      end

      adjacent_piece_of_same_color = @board.has_adjacent_piece_of_color?(piece.color, x, y)
      piece_of_same_color = @board.has_piece_of_color?(piece.color, x ,y)

      adjacent_piece_of_same_color || piece_of_same_color
    end
  end
end