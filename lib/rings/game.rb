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
      assign_arsenal_to_players
    end

    def current_player
      @players[@current_turn]
    end

    def is_in_turn? player
      current_player == player
    end

    def take_turn player, piece, x, y
      raise ArgumentError, "It's not this player's turn!" unless is_in_turn?(player)
      raise ArgumentError, "Cannot place this piece here." unless can_place_piece?(piece, x, y)

      player.remove_piece_from_arsenal(piece)
      @board.place(piece, x, y)
      @current_turn = (@current_turn + 1) % @players.size
    end

    def over?
      @players.all? do |player|
        @board.each_field.all? do |field|
          player.arsenal.all? { |piece| !field.can_place?(piece) }
        end
      end
    end

    def winner
      # Create a hash of players with the number of territories they have won
      territories_won = Hash[territory_winners
        .group_by { |territory_winner| territory_winner }
        .map { |territory_winner, won_territories| [territory_winner, won_territories.count] }]

      # Select the players with the most won territories
      winners = territories_won.select { |_, count| count == winners.values.max }.keys

      # In case of a tie, the player with the fewest remaining pieces in his arsenal wins
      winners.sort_by { |winner| winner.arsenal.length }.first
    end

    private

    def place_starting_pieces x, y
      @board.place(LargeRingPiece.new(:purple), x, y)
      @board.place(MediumRingPiece.new(:yellow), x, y)
      @board.place(SmallRingPiece.new(:green), x, y)
      @board.place(ExtraSmallRingPiece.new(:red), x, y)
    end

    def can_place_piece? piece, x, y
      return @board.can_place?(piece, x, y) &&
        (!piece.solid? || !@board.has_adjacent_piece_of_color?(piece.color, x, y)) &&
        (@board.has_adjacent_piece_of_color?(piece.color, x, y) ||
          @board.has_piece_of_color?(piece.color, x ,y))
    end

    def assign_arsenal_to_players
      raise NotImplementedError, "Sub class must implement this method"
    end

    def find_player_by_color color
      raise NotImplementedError, "Sub class must implement this method"
    end

    def territory_winners
      # Collect the winner (if any) of each territory. Fields occupied by
      # a solid piece do not affect the number of won territories.
      @board.each_field.reject(&:has_solid_piece?).collect do |field|
        # Make a list of the number of times each color occurres
        color_count = Pieces::ALLOWED_COLORS.map do |color|
          field.number_of_pieces_of_color(color)
        end

        # Check if there is a single color that has the most
        # rings with that color on this field
        if color_count.count(color_count.max) == 1
          # Find the index of that color and lookup the corresponding player
          index = color_count.index(color_count.max)
          find_player_by_color Pieces::ALLOWED_COLORS[index]
        end
      end
    end
  end
end
