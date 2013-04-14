# require 'spec_helper'
# require 'rings/game'
# require 'rings/command_handlers/send_message_command_handler'
# require 'support/shared_examples_for_command_handler'

# describe CommandHandlers::SendMessageCommandHandler do
#   it_behaves_like CommandHandler do
#     describe ".command" do
#       specify { described_class.command.should == 'send_message' }
#     end

#     describe "#handle_command" do
#       subject { described_class.new(session, "hello") }
      
#       let(:first_recipient) { double :recipient }
#       let(:second_recipient) { double :recipient }

#       before(:each) do
#         game = Game.new [first_recipient, second_recipient]
        
#         client_socket = double :client_socket
#         client_socket.stub(:game).and_return game
#         subject.stub(:client_socket).and_return client_socket

#         first_recipient.stub(:chat_supported?).and_return(true)
#         first_recipient.stub(:chat_supported?).and_return(true)
#         first_recipient.stub(:chat_supported?).and_return(false)

#         session.stub(:send_chat_message).and_return(true)
#       end

#       it "sends the message to all players that support chat" do
#         [first_recipient, second_recipient].each do |recipient|
#           recipient.should_receive(:send_command).with(:add_message, "thomas", "hello")
#         end

#         subject.handle_command
#       end
#     end
#   end
# end