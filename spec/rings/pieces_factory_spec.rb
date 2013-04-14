require 'spec_helper'
require 'rings/pieces_factory'

require 'rings/pieces/extra_small_solid_piece'
require 'rings/pieces/large_ring_piece'
require 'rings/pieces/large_solid_piece'
require 'rings/pieces/medium_ring_piece'
require 'rings/pieces/small_ring_piece'

describe PiecesFactory do
  describe ".create" do
    context "when creating an extra small solid piece" do
      specify do
        instance = PiecesFactory.create :extra_small_solid_piece, :yellow
        instance.class.should == Pieces::ExtraSmallSolidPiece
      end
    end

    context "when creating a large ring piece" do
      specify do
        instance = PiecesFactory.create :large_ring_piece, :yellow
        instance.class.should == Pieces::LargeRingPiece
      end
    end

    context "when creating a large sold piece" do
      specify do
        instance = PiecesFactory.create :large_solid_piece, :yellow
        instance.class.should == Pieces::LargeSolidPiece
      end
    end

    context "when creating a medium ring piece" do
      specify do
        instance = PiecesFactory.create :medium_ring_piece, :yellow
        instance.class.should == Pieces::MediumRingPiece
      end
    end

    context "when creating a small ring piece" do
      specify do
        instance = PiecesFactory.create :small_ring_piece, :yellow
        instance.class.should == Pieces::SmallRingPiece
      end
    end
  end
end

