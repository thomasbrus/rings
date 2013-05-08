require 'spec_helper'
require 'rings/games_factory'

require 'rings/games/two_player_game'
require 'rings/games/three_player_game'
require 'rings/games/four_player_game'

require 'support/acts_as_player'

describe GamesFactory do
  describe ".create" do
    %w[first second third fourth].each do |nth|      
      let("#{nth}_player") { Player.new }
    end

    context "when creating a two player game" do
      specify do
        players = [first_player, second_player]
        instance = GamesFactory.create(2, 2, players)
        instance.class.should == Games::TwoPlayerGame
      end
    end

    context "when creating a three player game" do
      specify do
        players = [first_player, second_player, third_player]
        instance = GamesFactory.create(2, 2, players)
        instance.class.should == Games::ThreePlayerGame
      end
    end

    context "when creating a four player game" do
      specify do
        players = [first_player, second_player, third_player, fourth_player]
        instance = GamesFactory.create(2, 2, players)
        instance.class.should == Games::FourPlayerGame
      end
    end

    context "when creating a game with an invalid number of players" do
      specify do
        expect {
          GamesFactory.create(2, 2, Array.new(5))
        }.to raise_error ArgumentError, /invalid number of players/i
      end    
    end
  end
end
