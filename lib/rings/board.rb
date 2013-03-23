require 'matrix'

module Rings
  class Board
    SIZE = 5

    def initialize
      @fields = Matrix.new(SIZE, SIZE) { |x, y| Field.new x, y }
    end

    def place x, y, piece
      unless (0...SIZE).include?(x) and (0...SIZE).include?(y) and can_place?(x, y, piece)
        raise ArgumentError, "Cannot place this piece here."
      end
      @fields[x, y].place piece
    end

    def can_place? x, y, piece
      adjacent_pieces.map(&:color).include? piece.color or @fields[x, y].has_piece_of_color? piece.color
    end

    def place_starting_pieces x, y
      @fields[x, y].place LargeRingPiece.new :purple
      @fields[x, y].place MediumRingPiece.new :yellow
      @fields[x, y].place SmallRingPiece.new :green
      @fields[x, y].place ExtraSmallSolidPiece.new :red
    end

    private

    def adjacent_pieces x, y
      @fields.each.select do |field|
        horizontal_distance = (x - field.x).abs
        vertical_distance = (y - field.y).abs
        horizontal_distance + vertical_distance == 1
      end
    end
  end
end