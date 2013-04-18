require 'spec_helper'
require 'rings/game'
require 'rings/command_handlers/send_message_command_handler'
require 'support/shared_examples_for_command_handler'

describe CommandHandlers::SendMessageCommandHandler do
  it_behaves_like CommandHandler do
    describe ".command" do
      specify { described_class.command.should == 'send_message' }
    end

    describe "#handle_command" do
      subject { described_class.new(session, "hello") }
      
      before(:each) do
        session.stub(:send_message!)
      end

      context "given a game exists with two players" do
        let(:sender) { client_socket }
        let(:first_recipient) { double :recipient }
        let(:second_recipient) { double :recipient }

        before(:each) do
          game = Game.new(1, 1, [first_recipient, second_recipient])
          client_socket.stub(:game).and_return(game)
          sender.stub(:nickname).and_return("thomas")
        end

        context "of which one supports chat" do
          before(:each) do
            first_recipient.stub(:chat_supported?).and_return(true)
            second_recipient.stub(:chat_supported?).and_return(false)
          end
       
          it "sends the chat message only to that one player" do
            first_recipient.should_receive(:send_command).with(:add_message, "thomas", "hello")
            subject.handle_command
          end
        end
      end
    end
  end
end