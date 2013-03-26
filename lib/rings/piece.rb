module Rings
  class Piece    
    ALLOWED_COLORS = [:red, :green, :yellow, :purple].freeze
    attr_reader :color

    def initialize color
      unless ALLOWED_COLORS.include? color
        raise ArgumentError, "Invalid color, allowed colors are #{ALLOWED_COLORS.inspect}"
      end
      @color = color
    end

    def solid?
      raise NotImplementedError, "Sub class must implemented this method"
    end

    def size
      raise NotImplementedError, "Sub class must implemented this method"
    end

  end
end