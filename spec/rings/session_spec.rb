require 'spec_helper'
require 'rings/command_handling'
require 'rings/session'

describe Session do
  let(:server) { double :server }
  let(:client_socket) { double :client_socket }
  let(:session) { Session.new(server, client_socket) }
  let(:logger) { double :logger }

  before(:each) do
    client_socket.stub(:eof?).and_return(true)
    client_socket.stub(:gets).and_return(nil)
    client_socket.stub(:nickname).and_return("thomas")
    server.stub(:with_connected_socket) { |&block| block.call }
    server.stub(:logger).and_return(logger)
    logger.stub(:info)
    logger.stub(:error)
    logger.stub(:warn)
  end

  describe ".new" do
    context "given a client socket that sends a stream of commands" do
      context "given an invalid command" do
        before(:each) do
          client_socket.stub(:gets).and_return("some_unknown_command", nil)
          client_socket.stub(:send_command)
        end
        
        it "sends the error message to the client" do
          message = /unknown command/i
          client_socket.should_receive(:send_command).with(:error, message)
          Session.new(server, client_socket)
        end

        it "sends the error message to the server" do
          logger.should_receive(:warn).with(/unknown_command/i)
          Session.new(server, client_socket)
        end
      end

      context "given a valid command and valid arguments" do
        it "parses a command and its arguments" do
          client_socket.stub(:gets).and_return("my_command arg1 arg2", nil)
          Session.any_instance.should_receive(:handle_incoming_command)
            .with("my_command", %w[arg1 arg2])
          Session.new(server, client_socket)
        end

        it "handles the join server command" do
          client_socket.stub(:gets).and_return("join_server thomas 1 1", nil)
          klass = CommandHandlers::JoinServerCommandHandler
          klass.any_instance.should_receive(:handle_command)
          Session.new(server, client_socket)
        end

        it "handles the request game command" do
          client_socket.stub(:gets).and_return("request_game 3", nil)
          klass = CommandHandlers::RequestGameCommandHandler
          klass.any_instance.should_receive(:handle_command)
          Session.new(server, client_socket)
        end

        it "handles the place piece command" do
          client_socket.stub(:gets).and_return("place_piece medium_ring_piece red 1 1", nil)
          klass = CommandHandlers::PlacePieceCommandHandler
          klass.any_instance.should_receive(:handle_command)
          Session.new(server, client_socket)
        end

        it "handles the send message command" do
          client_socket.stub(:gets).and_return(%q[send_message hello%20there], nil)
          klass = CommandHandlers::SendMessageCommandHandler
          klass.any_instance.should_receive(:handle_command)
          Session.new(server, client_socket)
        end
      end
    end
  end

  describe "#join_server" do
    context "when in the 'connected' state" do
      it "can perform the 'join server' event" do
        session.can_join_server?.should be_true
      end

      context "when performing the 'join server' event" do
        before(:each) { session.join_server! }

        it "transitions to the 'joined server' state" do
          session.state_name.should == :joined_server
        end
      end
    end
  end

  describe "#request_game" do
    context "when in the 'joined server' state" do
      before(:each) { session.join_server! }

      it "can perform the 'request game' event" do
        session.can_request_game?.should be_true          
      end

      context "when performing the 'request game' event" do
        before(:each) { session.request_game! }

        it "stays in the 'joined server' state" do
          session.state_name.should == :joined_server
        end
      end
    end
  end

  describe "#start_game" do
    context "when in the 'joined server' state" do
      before(:each) { session.join_server! }
      
      it "can perform the 'start game' event" do
        session.can_start_game?.should be_true          
      end

      context "when performing the 'start game' event" do
        before(:each) { session.start_game! }

        it "transitions to the 'in game' state" do
          session.state_name.should == :in_game
        end
      end
    end
  end

  describe "#send_message" do
    context "when in the 'in game' state" do
      before(:each) do
        session.join_server!
        session.start_game!
      end
      
      it "can perform the 'send message' event" do
        session.can_send_message?.should be_true          
      end

      context "when performing the 'send message' event" do
        before(:each) { session.send_message! }

        it "stays in the 'in game' state" do
          session.state_name.should == :in_game
        end
      end
    end
  end

  describe "#place_piece" do
    context "when in the 'in game' state" do
      before(:each) do
        session.join_server!
        session.start_game!
      end
      
      it "can perform the 'place piece' event" do
        session.can_place_piece?.should be_true          
      end

      context "when performing the 'place piece' event" do
        before(:each) { session.place_piece! }

        it "stays in the 'in game' state" do
          session.state_name.should == :in_game
        end
      end
    end
  end

  describe "#end_game" do
    context "when in the 'in game' state" do
      before(:each) do
        session.join_server!
        session.start_game!
      end
      
      it "can perform the 'end game' event" do
        session.can_end_game?.should be_true          
      end

      context "when performing the 'end game' event" do
        before(:each) { session.end_game! }

        it "transitions to the 'joined server' state" do
          session.state_name.should == :joined_server
        end
      end
    end
  end

  # TODO: .after_transition, .after_failure

end
