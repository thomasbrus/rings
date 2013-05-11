require 'spec_helper'
require 'rings/game'
require 'rings/waiting_queue'
require 'rings/command_handlers/request_game_command_handler'
require 'support/shared_examples_for_command_handler'

describe CommandHandlers::RequestGameCommandHandler do
  it_behaves_like CommandHandler do
    describe ".command" do
      specify { described_class.command.should == 'request_game' }
    end

    describe "#handle_command" do
      before(:each) do
        session.stub(:request_game!)
        session.stub(:can_request_game?).and_return(true)
      end

      context "given too few players" do
        subject { described_class.new(session, "1") }

        it "raises an error" do
          message = /wrong number of players/i
          expect { subject.handle_command
          }.to raise_error CommandHandling::CommandError, message
        end
      end

      context "given too many players" do
        subject { described_class.new(session, "5") }

        it "raises an error" do
          message = /wrong number of players/i
          expect { subject.handle_command
          }.to raise_error CommandHandling::CommandError, message
        end
      end

      context "given enough players" do
        subject { described_class.new(session, "3") }

        it "enqueus the session associated to the player" do
          WaitingQueue.instance_for(3).should_receive(:enqueue).with(session)
          subject.handle_command
        end

        # context "when the queue is ready" do
        #   let(:first_session) { double :session }
        #   let(:second_session) { double :session }

        #   before(:each) do
        #     first_session.stub(:puts)
        #     second_session.stub(:puts)
        #     WaitingQueue.instance_for(3).enqueue first_session
        #     WaitingQueue.instance_for(3).enqueue second_session
        #     session.stub(:start_game)
        #     first_session.stub(:start_game)
        #     second_session.stub(:start_game)
        #     first_session.stub(:client_socket).and_return(double(:client_socket))
        #     second_session.stub(:client_socket).and_return(double(:client_socket))
        #   end

        #   it "withdraws each player from all queues" do
        #     [first_session, second_session, session].each do |socket|
        #       WaitingQueue.should_receive(:withdraw).with(socket).ordered
        #     end
        #     subject.handle_command
        #   end
        # end
      end

      context "when it cannot request a game" do
      #   subject { described_class.new(session, "3") }

      #   before(:each) do
      #     session.stub(:can_request_game?).and_return(false)
      #   end

      #   it "sends an error message" do
      #     message = /request game command not allowed/i
      #     client_socket.should_receive(:send_command).with(:error, message)
      #     subject.handle_command
      #   end
      end
    end
  end
end
