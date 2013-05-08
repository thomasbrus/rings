require 'spec_helper'
require 'rings/pieces_factory'

require 'rings/pieces/extra_small_ring_piece'
require 'rings/pieces/large_ring_piece'
require 'rings/pieces/large_solid_piece'
require 'rings/pieces/medium_ring_piece'
require 'rings/pieces/small_ring_piece'

describe PiecesFactory do
  describe ".create" do
    context "when creating an extra small ring piece" do
      specify do
        instance = PiecesFactory.create(:extra_small_ring_piece, :yellow)
        instance.class.should == Pieces::ExtraSmallRingPiece
      end
    end

    context "when creating a large ring piece" do
      specify do
        instance = PiecesFactory.create(:large_ring_piece, :yellow)
        instance.class.should == Pieces::LargeRingPiece
      end
    end

    context "when creating a large sold piece" do
      specify do
        instance = PiecesFactory.create(:large_solid_piece, :yellow)
        instance.class.should == Pieces::LargeSolidPiece
      end
    end

    context "when creating a medium ring piece" do
      specify do
        instance = PiecesFactory.create(:medium_ring_piece, :yellow)
        instance.class.should == Pieces::MediumRingPiece
      end
    end

    context "when creating a small ring piece" do
      specify do
        instance = PiecesFactory.create(:small_ring_piece, :yellow)
        instance.class.should == Pieces::SmallRingPiece
      end
    end

    context "when creating a piece of an invalid type" do
      specify do
        expect { PiecesFactory.create(:something, :red)
        }.to raise_error ArgumentError, /invalid type/i
      end
    end
  end

  describe ".create_arsenal" do    
    context "when creating an arsenal of red pieces" do
      let(:arsenal) { PiecesFactory.create_arsenal(:red) }

      it "includes three red pieces of each type" do
        arsenal.should =~ [
          Rings::Pieces::LargeSolidPiece.new(:red),
          Rings::Pieces::LargeRingPiece.new(:red),
          Rings::Pieces::MediumRingPiece.new(:red),
          Rings::Pieces::SmallRingPiece.new(:red),
          Rings::Pieces::ExtraSmallRingPiece.new(:red)
        ] * 3
      end
    end

    context "when creating an arsenal of red and yellow pieces" do
      let(:arsenal) { PiecesFactory.create_arsenal(:red, :yellow) }

      it "includes three red pieces of each type and a yellow piece of each type" do
        arsenal.should =~ [
          Rings::Pieces::LargeSolidPiece.new(:red),
          Rings::Pieces::LargeRingPiece.new(:red),
          Rings::Pieces::MediumRingPiece.new(:red),
          Rings::Pieces::SmallRingPiece.new(:red),
          Rings::Pieces::ExtraSmallRingPiece.new(:red)
        ] * 3 + [
          Rings::Pieces::LargeSolidPiece.new(:yellow),
          Rings::Pieces::LargeRingPiece.new(:yellow),
          Rings::Pieces::MediumRingPiece.new(:yellow),
          Rings::Pieces::SmallRingPiece.new(:yellow),
          Rings::Pieces::ExtraSmallRingPiece.new(:yellow)        
        ]
      end
    end
  end
end