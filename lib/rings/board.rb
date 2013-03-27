require 'matrix'

require 'rings/field'
require 'rings/pieces/extra_small_solid_piece'
require 'rings/pieces/large_ring_piece'
require 'rings/pieces/large_solid_piece'
require 'rings/pieces/medium_ring_piece'
require 'rings/pieces/small_ring_piece'

include Rings::Pieces

module Rings
  class Board
    SIZE = 5

    def initialize
      @fields = Matrix.build(SIZE, SIZE) { |x, y| Field.new x, y }
    end

    def place x, y, piece
      raise ArgumentError, "Cannot place this piece here." unless can_place?(x, y, piece)
      @fields[x, y].place piece
    end

    def can_place? x, y, piece
      return (0...SIZE).include?(x) && (0...SIZE).include?(y) && @fields[x, y].can_place?(piece)
      # if piece.solid?
      #   return false if has_adjacent_solid_piece_of_color?(x, y, piece.color)
      # else
      #   return has_adjacent_piece_of_color?(x, y, piece.color) || @fields[x, y].has_piece_of_color?(x ,y, piece.color)
      # end
    end

    def place_starting_pieces x, y
      @fields[x, y].place LargeRingPiece.new :purple
      @fields[x, y].place MediumRingPiece.new :yellow
      @fields[x, y].place SmallRingPiece.new :green
      @fields[x, y].place ExtraSmallSolidPiece.new :red
    end

    # private

    # def adjacent_pieces x, y
    #   @fields.each.select do |field|
    #     horizontal_distance = (x - field.x).abs
    #     vertical_distance = (y - field.y).abs
    #     horizontal_distance + vertical_distance == 1
    #   end
    # end

    # def has_adjacent_solid_piece_of_color? x, y, color
    #   adjacent_pieces(x, y).any? { |f| f.has_solid_piece_of_color? color }
    # end

    # def has_adjacent_piece_of_color? x, y, color
    #   adjacent_pieces(x, y).any? { |f| f.has_piece_of_color? color }
    # end
  end
end