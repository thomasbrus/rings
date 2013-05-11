require 'spec_helper'
require 'rings/board'

include Rings::Pieces

describe Board do
  context "when the board is empty" do
    let(:board) { Board.new }

    describe "#can_place?" do
      let(:piece) { MediumRingPiece.new(:yellow) }

      context "when placed on the board" do
        it "can be placed" do
          board.can_place?(piece, 1, 1).should be_true
        end

        it "delegates #can_place?" do
          Rings::Field.any_instance.should_receive(:can_place?).with(piece)
          board.can_place?(piece, 1, 1)
        end
      end

      context "when placed outside of the board" do
        it "cannot be placed" do
          board.can_place?(piece, -1, 0).should be_false
        end
      end
    end

    describe "#place" do
      let(:piece) { LargeSolidPiece.new(:purple) }

      it "places the piece on the field" do
        Rings::Field.any_instance.should_receive(:place).once
        board.place piece, 2, 4
      end

      context "when it cannot place the piece" do
        before(:each) do
          board.stub(:can_place?).and_return(false)
        end

        it "raises an error" do
          expect { board.place piece, 2, 3 }.to raise_error ArgumentError
        end
      end
    end
  end
end
