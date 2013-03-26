require 'set'

module Rings
  class Field
    attr_reader :x, :y

    def initialize x, y
      @x, @y = x, y
      @pieces = Set.new
    end

    def place piece
      raise ArgumentError, "Cannot place this piece here." unless can_place? piece
      @pieces.add piece
    end

    def can_place? piece
      not (has_large_solid_piece? or has_piece_of_size?(piece.size))
    end

    def has_piece_of_size? size
      @pieces.map(&:size).include? size
    end

    def has_piece_of_color? color
      @pieces.map(&:color).include? color
    end
    
    private

    def has_large_solid_piece?
      @pieces.any? { |piece| piece.solid? && (piece.size == :large) }
    end
  end
end