require 'spec_helper'
require 'rings/board'

include Rings::Pieces

describe Board do
  context "when the board is empty" do
    let(:board) { Board.new }

    describe "#place_starting_pieces" do
      context "when placed on the board" do
        before(:each) do
          @pieces = []
          Rings::Field.any_instance.stub(:place) { |piece| @pieces << piece }
          board.place_starting_pieces 2, 3
        end

        it "includes a large, medium, small and extra small piece" do
          @pieces.map(&:size).should =~ [:large, :medium, :small, :extra_small]
        end

        it "includes a purple, yellow, green and red ring" do
          @pieces.map(&:color).should =~ [:purple, :yellow, :green, :red]
        end
      end
    end

    describe "#can_place?" do
      let(:piece) { MediumRingPiece.new(:yellow) }

      context "when placed on the board" do
        it "can be placed" do
          board.can_place?(1, 1, piece).should be_true
        end

        it "calls #can_place? on the field" do
          Rings::Field.any_instance.stub(:can_place?).and_return(true)
          Rings::Field.any_instance.should_receive(:can_place?).with(piece)
          board.can_place?(1, 1, piece)
        end
      end
      
      context "when placed outside of the board" do
        it "cannot be placed" do
          board.can_place?(-1, 0, piece).should be_false
        end
      end
    end

    describe "#place" do
      let(:piece) { LargeSolidPiece.new(:purple) }

      it "places the piece on the field" do
        Rings::Field.any_instance.should_receive(:place).once
        board.place 2, 4, piece
      end

      context "when it cannot place the piece" do
        before(:each) do
          board.stub(:can_place?).and_return(false)
        end

        it "throws an error" do
          expect { board.place 2, 3, piece }.to raise_error ArgumentError
        end
      end
    end
  end
end