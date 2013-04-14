require 'spec_helper'

require 'rings/command_handlers/place_piece_command_handler'
require 'support/shared_examples_for_command_handler'

describe CommandHandlers::PlacePieceCommandHandler do
  it_behaves_like CommandHandler do
    describe ".command" do
      specify { described_class.command.should == 'place_piece' }
    end

    describe "#handle_command" do
    end
  end
end