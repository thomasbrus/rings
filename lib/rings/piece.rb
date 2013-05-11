module Rings
  class Piece
    ALLOWED_COLORS = [:red, :green, :yellow, :purple].freeze
    attr_reader :color

    def initialize(color)
      unless ALLOWED_COLORS.include?(color)
        raise ArgumentError, "Invalid color, allowed colors are #{ALLOWED_COLORS.inspect}"
      end
      @color = color
    end

    def solid?
      raise NotImplementedError, "Sub class must implement this method"
    end

    def size
      raise NotImplementedError, "Sub class must implement this method"
    end

    def type
      [size, solid? ? 'solid' : 'ring', "piece"].join('_').to_sym
    end

    def == other
      color == other.color && size == other.size && solid? == other.solid?
    end
  end
end
