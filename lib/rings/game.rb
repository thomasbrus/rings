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

    def initialize players
      @board = Board.new
      @players = players
      @current_player = players.first
    end

    # TODO #take_turn, no state machine

    # turn

    def user_player(user)
      user.players.find_by_game_id(id)
    end

    def current_user_turn?(user)
      user_player(user) == current_player
    end

    def next_player?
      current_player_number < players.count
    end

    def next_player
      self.current_player = players[current_player_number % players.count]
    end

    def previous_player?
      current_player_number != 1
    end

    def previous_player
      self.current_player = players[(current_player_number - 2) % players.count]
    end

    def take_turn player, piece, x, y
      this.turn = (this.turn + 1) % this.players.size();       
      super
    end

    def place_piece type, color, x, y
      piece = PiecesFactory.create(type, color)
      raise ArgumentError, "Cannot place this piece here." unless can_place_piece? piece, x, y
      @board.place piece, x, y
    end

    def over?
      # ...
    end

    def winners
      # ...
    end

    def place_starting_pieces
      x = [1, 2, 3].sample
      y = [1, 2, 3].sample

      @board.place LargeRingPiece.new(:purple), x, y
      @board.place MediumRingPiece.new(:yellow), x, y
      @board.place SmallRingPiece.new(:green), x, y
      @board.place ExtraSmallSolidPiece.new(:red), x, y

      [x, y]
    end

    private

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