require 'spec_helper'
require 'rings/game'
require 'rings/games/two_player_game'

describe Game do
  let (:first_player) { double :player }
  let (:second_player) { double :player }

  before(:each) do
    first_player.stub(:arsenal=)
    second_player.stub(:arsenal=)
  end

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
      subject { Games::TwoPlayerGame.new 1, 1, first_player, second_player }  
      specify { subject.current_player.should == first_player }
    end
  end

  describe "#take_turn" do

  end

  describe "#over?" do

  end

  describe "#winners" do
    
  end

  # describe "#place_starting_pieces" do
  #   it "chooses a random field within a valid range" do
  #     Board.any_instance.should_receive(:place_starting_pieces).once do |x, y|
  #       x.should be_between 1, 3
  #       y.should be_between 1, 3
  #     end
  #     game.place_starting_pieces      
  #   end

  #   it "returns the x and y coordinates of the starting pieces" do
  #     x, y = game.place_starting_pieces
  #     x.should be_between 1, 3
  #     y.should be_between 1, 3
  #   end
  # end

end
