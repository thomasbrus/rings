require 'rings/pieces/extra_small_solid_piece'
require 'rings/pieces/large_ring_piece'
require 'rings/pieces/large_solid_piece'
require 'rings/pieces/medium_ring_piece'
require 'rings/pieces/small_ring_piece'

module Rings
  module PiecesFactory
    def create type, color
      case type
      when :extra_small_solid_piece
        Rings::Pieces::ExtraSmallSolidPiece.new(color)
      when :large_ring_piece
        Rings::Pieces::LargeRingPiece.new(color)
      when :large_solid_piece
        Rings::Pieces::LargeSolidPiece.new(color)
      when :medium_ring_piece
        Rings::Pieces::MediumRingPiece.new(color)
      when :small_ring_piece
        Rings::Pieces::SmallRingPiece.new(color)
      else
        raise ArgumentError, %Q[Invalid type: "#{type}"]
      end
    end

    module_function :create
  end
end
