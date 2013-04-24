require 'rings/pieces/extra_small_ring_piece'
require 'rings/pieces/large_ring_piece'
require 'rings/pieces/large_solid_piece'
require 'rings/pieces/medium_ring_piece'
require 'rings/pieces/small_ring_piece'

module Rings
  module PiecesFactory
    def self.create type, color
      case type
      when :extra_small_ring_piece
        Rings::Pieces::ExtraSmallRingPiece.new(color)
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

    def self.create_arsenal color, shared_color = nil
      arsenal = [
        Rings::Pieces::LargeSolidPiece.new(color),
        Rings::Pieces::LargeRingPiece.new(color),
        Rings::Pieces::MediumRingPiece.new(color),
        Rings::Pieces::SmallRingPiece.new(color),
        Rings::Pieces::ExtraSmallRingPiece.new(color)
      ] * 3

      if shared_color
        arsenal << Rings::Pieces::LargeSolidPiece.new(shared_color)
        arsenal << Rings::Pieces::LargeRingPiece.new(shared_color)
        arsenal << Rings::Pieces::MediumRingPiece.new(shared_color)
        arsenal << Rings::Pieces::SmallRingPiece.new(shared_color)
        arsenal << Rings::Pieces::ExtraSmallRingPiece.new(shared_color)        
      end

      arsenal
    end
  end
end
