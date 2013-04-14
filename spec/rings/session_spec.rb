require 'spec_helper'
require 'rings/command_handling'
require 'rings/session'

describe Session do
  let(:server) { double :server }
  let(:client_socket) { double :client_socket }
  let(:session) { Session.new(server, client_socket) }

  before(:each) do
    client_socket.stub(:eof?).and_return(true)
    server.stub(:with_connected_client) { |&block| block.call }
  end

  describe ".new" do
    context "given a client socket that sends a stream of commands" do
      before(:each) do
        client_socket.stub(:eof?).and_return(false, true)
      end

      context "given an invalid command" do
        before(:each) do
          client_socket.stub(:gets).and_return("some_unknown_command")
          client_socket.stub(:send_command)
          server.stub(:puts)
        end
        
        it "sends the error message to the client" do
          message = /unknown command/i
          client_socket.should_receive(:send_command).with(:error, message)
          Session.new(server, client_socket)
        end

        it "sends the error message to the server" do
          server.should_receive(:puts).with(/unknown_command/i)
          Session.new(server, client_socket)
        end
      end

      context "given a valid command and valid arguments" do
        it "parses a command and its arguments" do
          client_socket.stub(:gets).and_return("my_command arg1 arg2")
          Session.any_instance.should_receive(:handle_incoming_command)
            .with("my_command", %w[arg1 arg2])
          Session.new(server, client_socket)
        end

        it "handles the join server command" do
          client_socket.stub(:gets).and_return("join_server thomas 1 1")
          klass = CommandHandlers::JoinServerCommandHandler
          klass.any_instance.should_receive(:handle_command)
          Session.new(server, client_socket)
        end

        it "handles the request game command" do
          client_socket.stub(:gets).and_return("request_game 3")
          klass = CommandHandlers::RequestGameCommandHandler
          klass.any_instance.should_receive(:handle_command)
          Session.new(server, client_socket)
        end

        it "handles the place piece command" do
          client_socket.stub(:gets).and_return("place_piece medium_ring_piece red 1 1")        
          klass = CommandHandlers::PlacePieceCommandHandler
          klass.any_instance.should_receive(:handle_command)
          Session.new(server, client_socket)
        end

        it "handles the send message command" do
          client_socket.stub(:gets).and_return(%q[send_message hello%20there])
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

        it "is now in the 'joined server' state" do
          session.state_name.should == :joined_server
        end
      end
    end

    context "when not in the 'connected' state" do
      before(:each) { session.join_server! }

      context "when performing the 'join server' event" do
        it "sends an error message" do
          message = /join command not allowed/i
          client_socket.should_receive(:send_command).with(:error, message)
          session.join_server
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

        it "is still in the 'joined server' state" do
          session.state_name.should == :joined_server
        end
      end
    end

    context "when not in the 'joined server' state" do
      context "when performing the 'request_game' event" do
        it "sends an error message" do
          message = /request game command not allowed/i
          client_socket.should_receive(:send_command).with(:error, message)
          session.request_game
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

        it "is now in the 'in game' state" do
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

        it "is still in the 'in game' state" do
          session.state_name.should == :in_game
        end
      end
    end

    context "when not in the 'in game' state" do
      context "when performing the 'send_message' event" do
        it "sends an error message" do
          message = /chat command not allowed/i
          client_socket.should_receive(:send_command).with(:error, message)
          session.send_message
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

        it "is still in the 'in game' state" do
          session.state_name.should == :in_game
        end
      end
    end

    context "when not in the 'in game' state" do
      context "when performing the 'place_piece' event" do
        it "sends an error message" do
          message = /place piece command not allowed/i
          client_socket.should_receive(:send_command).with(:error, message)
          session.place_piece
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

        it "is now in the 'joined server' state" do
          session.state_name.should == :joined_server
        end
      end
    end
  end
end