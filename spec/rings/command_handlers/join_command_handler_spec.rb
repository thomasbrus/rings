require 'spec_helper'
require 'rings/game'
require 'rings/waiting_queue'
require 'rings/command_handlers/join_command_handler'
require 'support/shared_examples_for_command_handler'

describe CommandHandlers::JoinCommandHandler do
  it_behaves_like CommandHandler do
    describe ".command" do
      specify { described_class.command.should == 'join' }
    end

    describe "#handle_command" do 
      context "given valid arguments" do
        context "given too few players" do
          it "sends an error message" do
            client_socket.should_receive(:puts)
              .with(%q[error "Wrong number of players (1 for 2-4)"])
            subject.handle_command("1")
          end
        end

        context "given too many players" do
          it "sends an error message" do
            client_socket.should_receive(:puts)
              .with(%q[error "Wrong number of players (5 for 2-4)"])
            subject.handle_command("5")
          end
        end

        context "given enough players" do
          it "enqueus the player" do
            WaitingQueue.instance_for(3).should_receive(:enqueue).once
              .with(client_socket)
            subject.handle_command("3")
          end

          context "when the queue is ready" do
            let(:first_client_socket) { double :client_socket }
            let(:second_client_socket) { double :client_socket }

            before(:each) do
              first_client_socket.stub(:puts)
              second_client_socket.stub(:puts)
              WaitingQueue.instance_for(3).enqueue first_client_socket
              WaitingQueue.instance_for(3).enqueue second_client_socket              
            end

            it "withdraws each player from all queues" do
              [first_client_socket, second_client_socket, client_socket].each do |socket|
                WaitingQueue.should_receive(:withdraw).with(socket).ordered
              end
              subject.handle_command("3")
            end
          end
        end
      end
    end
  end
end