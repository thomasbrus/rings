require 'spec_helper'
require 'support/mock_block'

# Override the initialize method so that it doesn't actually start a tcp server
Server.send(:define_method, :initialize) do |port|
  @port = port
  @sockets = []
end

describe Server do
  subject(:server) { described_class.new 4567 }

  let(:first_client) { double :client }
  let(:second_client) { double :client }

  its(:port) { subject.port.should == 4567 }

  before(:each) do
    first_client.stub(:name).and_return('First client')
    second_client.stub(:name).and_return('Second client')
    first_client.stub(:close)
    second_client.stub(:close)
  end

  describe "#with_connected_socket" do  
    context "when given a block" do
      let(:block) { MockBlock.new }

      it "yields the block" do
        block.should_receive(:call)
        server.with_connected_socket first_client, &block
      end

      it "closes the client socket" do
        first_client.should_receive(:close)
        server.with_connected_socket(first_client) {}
      end

      context "when the name is taken" do
        before(:each) do
          server.stub(:nickname_taken?).and_return(true)
        end

        it "raises an error" do
          expect {
            server.with_connected_socket(first_client) {}
          }.to raise_error Server::NickNameTakenError
        end
      end
    end
  end

  describe "#nickname_taken?" do
    context "when checking if a name is taken" do
      context "when no sockets are connected" do
        specify { server.nickname_taken?('Some client').should be_false }
      end

      context "when a socket with that name is connected" do
        specify do
          server.with_connected_socket first_client do
            server.nickname_taken?('First client').should be_true
          end
        end
      end

      context "after the socket with that name was connected" do
        specify do
          server.with_connected_socket(first_client) {}
          server.nickname_taken?('First client').should be_false
        end          
      end
    end
  end

  describe "#chat_supported?" do
    specify { expect(subject.chat_supported?).to be_true }
  end

  describe "#challenge_supported?" do
    specify { expect(subject.challenge_supported?).to be_true }
  end
end
