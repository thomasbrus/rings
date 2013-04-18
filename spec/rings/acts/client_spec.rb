require 'spec_helper'
require 'rings/game'
require 'rings/acts/client'

describe Acts::Client do
  subject { Class.new { include Acts::Client }.new }

  describe ".acts_as_client" do
    before(:each) { subject.class.send :acts_as_client }
    
    it { should respond_to :nickname }
    it { should respond_to :nickname= }

    describe "#chat_supported?" do
      context "when it supports chat" do
        before(:each) { subject.chat_supported = true }
        specify { subject.chat_supported?.should be_true }
      end
    end
    
    describe "challenge_supported?" do
      context "when it supports challenge" do
        before(:each) { subject.challenge_supported = true }
        specify { subject.challenge_supported?.should be_true }
      end
    end

    describe "#send_command" do      
      it "encodes the arguments" do
        subject.should_receive(:puts).with("send_message hello%20there")
        subject.send_command(:send_message, "hello there")
      end

      it "uses spaces the join the command and it arguments" do
        subject.should_receive(:puts).with("send_message thomas hello")
        subject.send_command(:send_message, "thomas", "hello")
      end
    end
  end
end