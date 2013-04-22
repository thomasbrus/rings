require 'spec_helper'
require 'rings/field'

require 'rings/pieces/large_ring_piece'
require 'rings/pieces/large_solid_piece'
require 'rings/pieces/medium_ring_piece'
require 'rings/pieces/small_ring_piece'
include Rings::Pieces

describe Field do
  subject { Field.new 2, 4 }
  
  describe "#place" do
    let(:piece) { LargeSolidPiece.new(:purple) }

    context "when it cannot place the piece" do
      before(:each) do
        subject.stub(:can_place?).and_return(false)
      end

      it "raises an error" do
        expect { subject.place piece }.to raise_error ArgumentError
      end
    end
  end

  describe "#can_place?" do

    context "when the field is empty" do
      let(:piece) { LargeRingPiece.new(:green) }
      specify { subject.can_place?(piece).should be_true }
    end

    it "cannot place two pieces of the same size" do
      subject.place(MediumRingPiece.new(:red))
      subject.can_place?(MediumRingPiece.new(:green)).should be_false
    end

    context "when a solid piece is placed" do
      before(:each) do
        subject.place LargeSolidPiece.new(:green)
      end

      it "cannot place any other piece" do
        subject.can_place?(SmallRingPiece.new(:yellow))
      end
    end
    
  end

  describe "#has_piece_of_size?" do
    context "when the field is empty" do
      specify { should_not have_piece_of_size(:large) }  
    end

    context "when a large piece is placed" do
      before(:each) { subject.place LargeRingPiece.new(:red) }
      
      it "has a large piece" do
        should have_piece_of_size(:large)
      end
      
      it "does not have a small piece" do
        should_not have_piece_of_size(:small)
      end
    end
  end

  describe "#has_piece_of_color?" do
    context "when the field is empty" do
      specify { should_not have_piece_of_color(:yellow) }
    end

    context "when a yellow piece is placed" do
      before(:each) { subject.place SmallRingPiece.new(:yellow) }
      
      it "has a yellow piece" do
        should have_piece_of_color(:yellow)
      end

      it "does not have a red piece" do
        should_not have_piece_of_size(:red)
      end
    end
  end

  describe "#has_solid_piece?" do
    context "when a solid piece is placed" do
      before(:each) { subject.place LargeSolidPiece.new(:green) }
      specify { should have_solid_piece }
    end
  end

  describe "#number_of_pieces_for_color" do
    context "when two red colored pieces are placed" do
      before(:each) do
        subject.place SmallRingPiece.new(:red)
        subject.place LargeRingPiece.new(:red)
      end

      it "has two red colored pieces" do
        subject.number_of_pieces_of_color(:red).should == 2
      end

      it "has no yellow colored pieces" do
        subject.number_of_pieces_of_color(:yellow).should == 0
      end
    end
  end
end
