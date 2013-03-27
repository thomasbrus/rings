require 'spec_helper'
require 'rings/game'
require 'rings/acts/client'

describe Acts::Client do
  subject { Class.new { include Acts::Client }.new }

  describe ".acts_as_client" do
    before(:each) { subject.class.send :acts_as_client }
    
    context "when name is set" do
      before(:each) { subject.nickname = 'thomas' }

      describe "#nickname" do
        specify { subject.nickname.should == 'thomas' }  
      end      
    end

    context "when in game" do
      let(:dummy_game) { double :game }
      before(:each) { subject.game = dummy_game }

      describe "#game" do
        specify { subject.game.should == dummy_game }  
      end

      describe "#in_game?" do
        specify { subject.in_game?.should be_true }
      end      
    end

    context "when it supports chat" do
      before(:each) { subject.chat_supported = true }
      
      describe "#chat_supported?" do
        specify { subject.chat_supported?.should be_true }
      end
    end

    context "when it supports challenge" do
      before(:each) { subject.challenge_supported = true }

      describe "challenge_supported?" do
        specify { subject.challenge_supported?.should be_true }
      end
    end
  end
end