require 'spec_helper'
require 'rings/command_handlers/join_command_handler'
require 'support/shared_examples_for_command_handler'

describe CommandHandlers::JoinCommandHandler do
  it_behaves_like CommandHandler do
    context "when calling with valid arguments" do
      subject { described_class.new client_handler, "4" }
      its(:number_of_players) { should == 4 }
    end

    context "when calling with zero arguments" do
      it "throws an error" do
        expect { described_class.new client_handler }.to raise_error
      end
    end

    context "when calling with invalid arguments" do
      it "throws an error" do
        expect { described_class.new client_handler, *%w[test_me] }.to raise_error
      end
    end
  end
end

describe CommandHandlers::JoinCommandHandler, "with regard to it's command" do
  it { described_class.command.should == 'join' }
end