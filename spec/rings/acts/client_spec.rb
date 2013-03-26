require 'spec_helper'
require 'rings/acts/client'

describe Object do
  context "when it acts as client" do
    before(:each) { described_class.send :extend, Acts::Client }
    before(:each) { described_class.send :acts_as_client }
    subject(:instance ) { described_class.new }
    
    it { should respond_to :chat_supported? }
    it { should respond_to :challenge_supported? }
    it { should respond_to :name }

    context "when it's name is set" do
      before(:each) { instance.name = 'thomas' }
      its(:name) { should == 'thomas' }
    end

    context "when it supports chat" do
      before(:each) { instance.chat_supported = true }
      its(:chat_supported?) { should be_true }
    end

    context "when it supports challenge" do
      before(:each) { instance.challenge_supported = true }
      its(:challenge_supported?) { should be_true }
    end
  end
end