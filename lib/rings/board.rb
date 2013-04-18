require 'matrix'
require 'forwardable'

require 'rings/field'
require 'rings/pieces/extra_small_ring_piece'
require 'rings/pieces/large_ring_piece'
require 'rings/pieces/large_solid_piece'
require 'rings/pieces/medium_ring_piece'
require 'rings/pieces/small_ring_piece'

include Rings::Pieces

module Rings
  class Board
    extend Forwardable
    def_delegator :@fields, :each, :each_field
    
    SIZE = 5

    def initialize
      @fields = Matrix.build(SIZE, SIZE) { |x, y| Field.new x, y }
    end

    def place piece, x, y
      raise ArgumentError, "Cannot place this piece here." unless can_place? piece, x, y
      @fields[x, y].place piece
    end

    def can_place? piece, x, y
      return (0...SIZE).include?(x) && (0...SIZE).include?(y) && @fields[x, y].can_place?(piece)
    end

    def has_piece_of_color? color, x, y
      @fields[x, y].has_piece_of_color? piece.color
    end

    def has_adjacent_solid_piece_of_color? color, x, y
      adjacent_pieces(x, y).any? { |p| p.has_solid_piece_of_color?(color) }
    end

    def has_adjacent_piece_of_color? color, x, y
      adjacent_pieces(x, y).any? { |p| p.has_piece_of_color?(color) }
    end

    private

    def adjacent_pieces x, y
      @fields.select do |field|
        horizontal_distance = (x - field.x).abs
        vertical_distance = (y - field.y).abs
        horizontal_distance + vertical_distance == 1
      end
    end
  end
end