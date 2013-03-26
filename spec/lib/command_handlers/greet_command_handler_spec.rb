require 'spec_helper'
require 'rings/command_handlers/greet_command_handler'
require 'support/shared_examples_for_command_handler'

describe CommandHandlers::GreetCommandHandler do
  it_behaves_like CommandHandler do
    context "when calling with valid arguments" do
      subject { described_class.new client_handler, *%w[thomas 1 1] }
      its(:name) { should == "thomas" }
      its(:chat_supported?) { should be_true }
      its(:challenge_supported?) { should be_true }
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

    context "when name is taken" do
      it "sends an error message" do
        server.stub(:name_taken?).and_return true
        client_socket.should_receive(:puts).with %q[error "Name 'thomas' is already taken."]
        described_class.new client_handler, *%w[thomas 1 1]
      end
    end

    context "when name is not taken" do
      it "sends a success message" do
        client_socket.should_receive(:puts).with "greet 1 1"
        described_class.new client_handler, *%w[thomas 1 1]
      end
    end
  end
end

describe CommandHandlers::GreetCommandHandler, "with regard to it's command" do
  it { described_class.command.should == 'greet' }
end