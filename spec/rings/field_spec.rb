require 'spec_helper'
require 'rings/field'

require 'rings/pieces/large_ring_piece'
require 'rings/pieces/large_solid_piece'
require 'rings/pieces/medium_ring_piece'
require 'rings/pieces/small_ring_piece'
include Rings::Pieces

describe Field do
  context "when the field is empty" do
    subject(:field) { Field.new 2, 4 }
    
    describe "#place" do
      let(:piece) { LargeSolidPiece.new(:purple) }

      context "when it cannot place the piece" do
        before(:each) do
          field.stub(:can_place?).and_return(false)
        end

        it "raises an error" do
          expect { field.place piece }.to raise_error ArgumentError
        end
      end
    end

    describe "#can_place?" do
      context "when the field is empty" do
        let(:piece) { LargeRingPiece.new(:green) }
        specify { field.can_place?(piece).should be_true }
      end

      context "when a certain piece is placed" do
        let(:red_medium_sized_piece) { MediumRingPiece.new(:red) }
        let(:yellow_medium_sized_piece) { MediumRingPiece.new(:red) }
        before(:each) { field.place red_medium_sized_piece }

        it "cannot place it again" do
          field.can_place?(red_medium_sized_piece).should be_false
        end

        it "cannot place another piece of the same size" do
          field.can_place?(yellow_medium_sized_piece).should be_false
        end
      end
    end

    describe "#has_piece_of_size?" do
      context "when the field is empty" do
        specify { should_not have_piece_of_size(:large) }  
      end

      context "when a large piece is placed" do
        before(:each) { field.place LargeRingPiece.new(:red) }
        
        it "has a large piece" do
          should have_piece_of_size(:large)
        end
        
        it "does not have a small piece" do
          should_not have_piece_of_size(:small)
        end
      end
    end

    describe "has_piece_of_color?" do
      context "when the field is empty" do
        specify { should_not have_piece_of_color(:yellow) }
      end

      context "when a yellow piece is placed" do
        before(:each) { field.place SmallRingPiece.new(:yellow) }
        
        it "has a yellow piece" do
          should have_piece_of_color(:yellow)
        end

        it "does not have a red piece" do
          should_not have_piece_of_size(:red)
        end
      end
    end
  end
end
