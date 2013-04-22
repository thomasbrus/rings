require 'spec_helper'

require 'rings/command_handlers/place_piece_command_handler'
require 'support/shared_examples_for_command_handler'

describe CommandHandlers::PlacePieceCommandHandler do
  it_behaves_like CommandHandler do
    describe ".command" do
      specify { described_class.command.should == 'place_piece' }
    end

    describe "#handle_command" do
      subject do
        described_class.new(session, "large_solid_piece", "red", "1", "2")
      end

      context "when it cannot place a piece" do
        # before(:each) do
        #   session.stub(:can_place_piece?).and_return(false)
        # end

        # it "sends an error message" do
        #   message = /place piece command not allowed/i
        #   client_socket.should_receive(:send_command).with(:error, message)
        #   subject.handle_command
        # end        
      end
    end
  end
end
