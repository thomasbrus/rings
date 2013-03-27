require 'spec_helper'
require 'rings/game'

describe Game do
  describe ".new" do
    let(:board) { double :board }
    
    it "places the starting pieces" do    
      Board.any_instance.should_receive(:place_starting_pieces).once do |x, y|
        x.should be_between 1, 3
        y.should be_between 1, 3
      end
      Game.new []
    end
  end

end