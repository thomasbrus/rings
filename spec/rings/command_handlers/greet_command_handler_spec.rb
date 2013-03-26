require 'spec_helper'

require 'rings/command_handlers/greet_command_handler'
require 'support/shared_examples_for_command_handler'

describe CommandHandlers::GreetCommandHandler do
  it_behaves_like CommandHandler do
    describe ".command" do
      specify { described_class.command.should == 'greet' }
    end

    describe "#handle_command" do
      context "given valid arguments" do
        context "when the name is taken" do
          before(:each) { server.stub(:name_taken?).and_return(true) }

          it "sends an error message" do
            client_socket.should_receive(:puts)
              .with(%q[error "Name 'thomas' is already taken."])
            subject.handle_command(*%w[thomas 1 1])
          end
        end

        context "when the name is not taken" do
          it "stores the name of the client" do
            client_socket.stub(:puts)
            client_socket.should_receive(:name=).with("thomas")
            subject.handle_command(*%w[thomas 1 1])            
          end

          it "stores whether the client supports chat functionality" do
            client_socket.stub(:puts)
            client_socket.should_receive(:chat_supported=).with(true)
            subject.handle_command(*%w[thomas 1 1])
          end

          it "stores whether the client supports challenge functionality" do
            client_socket.stub(:puts)
            client_socket.should_receive(:challenge_supported=).with(true)
            subject.handle_command(*%w[thomas 1 1])
          end

          it "send a response message" do
            client_socket.should_receive(:puts)
              .with(%q[greet 1 1])
            subject.handle_command(*%w[thomas 1 1])
          end
        end
      end
    end
  end
end