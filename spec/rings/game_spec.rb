require 'spec_helper'

require 'rings/game'
require 'rings/games/two_player_game'

require 'support/acts_as_player'

describe Game do
  %w[first second].each do |nth|
    let("#{nth}_player") { Player.new }
  end

  subject { Games::TwoPlayerGame.new(1, 1, first_player, second_player) }
  let(:piece) { Pieces::SmallRingPiece.new(:red) }

  describe ".new" do
    context "given no players" do
      it "raises an error" do

      end
    end

    context "given invalid x and y coordinates" do
      it "raises an error" do

      end
    end
  end

  describe "#current_player" do
    context "when starting a new game" do
      # TODO: Move to two_player_game_spec.rb
      specify { subject.current_player.should == first_player }
    end
  end

  describe "#is_in_turn?" do
    subject { Games::TwoPlayerGame.new(1, 1, first_player, second_player) }

    context "when in turn" do
      specify { subject.is_in_turn?(first_player).should be_true }
    end

    context "when not in turn" do
      specify { subject.is_in_turn?(second_player).should be_false }
    end
  end

  describe "#take_turn" do
    context "when it's not this players turn" do
      it "raises an error" do
        expect {
          subject.take_turn(second_player, piece, 1, 2)
        }.to raise_error ArgumentError, /not this player's turn/i
      end
    end

    context "when it cannot place the piece" do
      # TODO: More specs for different situations
      it "raises an error" do
        expect {
          subject.take_turn(first_player, piece, 1, 4)
        }.to raise_error ArgumentError, /cannot place this piece/i
      end
    end
  end

  describe "#over?" do
    context "when the game is over" do

    end

    context "when the game is not over" do

    end
  end

  describe "#winner" do

  end

end
