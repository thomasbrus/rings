require 'set'

module Rings
  class Field
    attr_reader :x, :y

    def initialize x, y
      @x, @y = x, y
      @pieces = Set.new
    end

    def place piece
      raise ArgumentError, "Cannot place this piece here." unless can_place?(piece)
      @pieces.add(piece)
    end

    def can_place? piece
      !(has_solid_piece? || has_piece_of_size?(piece.size))
    end

    def has_piece_of_size? size
      @pieces.map(&:size).include? size
    end

    def has_piece_of_color? color
      @pieces.map(&:color).include? color
    end
    
    def has_solid_piece?
      @pieces.any? { |piece| piece.solid? }
    end

    def has_solid_piece_of_color? color
      @pieces.any? { |piece| piece.solid? && piece.color == color }
    end

    def number_of_pieces_of_color color
      @pieces.count { |piece| piece.color == color }
    end
  end
end
