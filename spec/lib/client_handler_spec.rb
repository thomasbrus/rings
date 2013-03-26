require 'spec_helper'
require 'rings/client_handler'

describe ClientHandler do
  describe ".new" do
    let(:server) { double :server }
    let(:client_socket) { double :client_socket }

    before(:each) do
      client_socket.stub(:eof?).and_return(false, true)
      server.stub(:with_connected_socket) { |&arg| arg.call }
    end

    it "parses a command and its arguments" do
      client_socket.stub(:gets).and_return("my_command arg1 arg2")
      ClientHandler.any_instance.should_receive(:handle_incoming_command)
        .with("my_command", %w[arg1 arg2])
      ClientHandler.new server, client_socket 
    end

    it "handles the greet command" do      
      client_socket.stub(:gets).and_return("greet")
      CommandHandlers::GreetCommandHandler.should_receive(:new)
      ClientHandler.new server, client_socket
    end

    it "handles the join command" do
      client_socket.stub(:gets).and_return("join")
      CommandHandlers::JoinCommandHandler.should_receive(:new)
      ClientHandler.new server, client_socket
    end

    context "when an invalid command is given" do
      before(:each) do
        client_socket.stub(:gets).and_return("unknown_command")
      end
      
      it "throws an error" do
        expect { ClientHandler.new server, client_socket
        }.to raise_error ClientHandler::UnknownCommandError
      end  
    end    
  end
end