require 'spec_helper'
require 'rings/game'
require 'rings/acts/player'

describe Acts::Player do
  subject { Class.new { include Acts::Player }.new }

  describe ".acts_as_player" do
    before(:each) { subject.class.send :acts_as_player }

    it { should respond_to :game }
    it { should respond_to :game= }
    it { should respond_to :arsenal }
    it { should respond_to :arsenal= }

    context "when in game" do
      let(:dummy_game) { double :game }
      before(:each) { subject.game = dummy_game }

      describe "#in_game?" do
        specify { subject.should be_in_game }
      end

      describe "#take_turn" do
        it "delegates to game#take_turn" do
          dummy_game.should_receive(:take_turn).with(subject, :piece, 1, 2)
          subject.take_turn(:piece, 1, 2)
        end
      end

      describe "#remove_piece_from_arsenal" do
        before(:each) do
          subject.arsenal = [:something, :something]
        end

        it "removes the piece only once" do
          subject.remove_piece_from_arsenal(:something)
          subject.arsenal.count(:something).should == 1
        end

        it "raises an error if the piece is not in the arsenal" do
          expect {
            subject.remove_piece_from_arsenal(:something_else)
          }.to raise_error ArgumentError
        end
      end

      describe "#can_remove_piece_from_arsenal?" do
        before(:each) do
          subject.arsenal = [:something]
        end

        it "can remove a piece that is in the arsenal" do
          subject.can_remove_piece_from_arsenal?(:something).should be_true
        end

        it "cannot remove a piece that is not in the arsenal" do
          subject.can_remove_piece_from_arsenal?(:something_else).should be_false
        end
      end
    end
  end
end
