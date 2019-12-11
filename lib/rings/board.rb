require 'matrix'
require 'forwardable'
require 'rings/field'
require 'rings/pieces/extra_small_ring_piece'
require 'rings/pieces/large_ring_piece'
require 'rings/pieces/large_solid_piece'
require 'rings/pieces/medium_ring_piece'
require 'rings/pieces/small_ring_piece'
require 'colored'

module Rings
  class Board
    SIZE = 5

    def initialize
      @fields = Matrix.build(SIZE, SIZE) { |x, y| Field.new x, y }
    end

    def each_field(&blk)
      @fields.each(&blk)
    end

    def place(piece, x, y)
      raise ArgumentError, "Cannot place this piece here." unless can_place?(piece, x, y)
      @fields[x, y].place piece
    end

    def can_place?(piece, x, y)
      return (0...SIZE).include?(x) && (0...SIZE).include?(y) && @fields[x, y].can_place?(piece)
    end

    def has_piece_of_color?(color, x, y)
      @fields[x, y].has_piece_of_color? color
    end

    def has_adjacent_solid_piece_of_color?(color, x, y)
      adjacent_fields(x, y).any? { |f| f.has_solid_piece_of_color?(color) }
    end

    def has_adjacent_piece_of_color?(color, x, y)
      adjacent_fields(x, y).any? { |f| f.has_piece_of_color?(color) }
    end

    def adjacent_fields(x, y)
      @fields.select do |field|
        horizontal_distance = (x - field.x).abs
        vertical_distance = (y - field.y).abs
        horizontal_distance + vertical_distance == 1
      end
    end
  end
end
