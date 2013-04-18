require 'spec_helper'

require 'rings/command_handlers/join_server_command_handler'
require 'support/shared_examples_for_command_handler'

describe CommandHandlers::JoinServerCommandHandler do
  it_behaves_like CommandHandler do
    describe ".command" do
      specify { described_class.command.should == 'join_server' }
    end

    describe "#handle_command" do
      subject { described_class.new(session, "thomas", "1", "1") }

      before(:each) do
        session.stub(:join_server!)
        client_socket.stub(:send_command)
      end

      context "when the nickname is taken" do
        before(:each) { server.stub(:nickname_taken?).and_return(true) }

        it "raises an error" do
          message = /nickname "thomas" is already taken/i
          expect { subject.handle_command
          }.to raise_error CommandHandling::CommandError, message
        end
      end

      context "when the nickname is not taken" do
        it "stores the nickname of the client" do
          client_socket.should_receive(:nickname=).with("thomas")
          subject.handle_command
        end

        it "stores whether the client supports chat functionality" do
          client_socket.should_receive(:chat_supported=).with(true)
          subject.handle_command
        end

        it "stores whether the client supports challenge functionality" do
          client_socket.should_receive(:challenge_supported=).with(true)
          subject.handle_command
        end

        it "notifies the client whether the server supports chat" do
          client_socket.should_receive(:send_command).with(:notify_chat_support, 1)
          subject.handle_command
        end

        it "notifies the client whether the server supports challenge" do
          client_socket.should_receive(:send_command).with(:notify_challenge_support, 0)
          subject.handle_command
        end
      end
    end
  end
end