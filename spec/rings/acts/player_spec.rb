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
        specify { subject.in_game?.should be_true }
      end

      describe "#take_turn" do
        it "delegates to game#take_turn" do
          dummy_game.should_receive(:take_turn).with(subject, :piece, 1, 2)
          subject.take_turn(:piece, 1, 2)
        end
      end
    end
  end
end
