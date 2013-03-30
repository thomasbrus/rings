require 'spec_helper'
require 'rings/command_handling'
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

    context "given a valid command" do
      let(:command_handler) { double :command_handler }
      before(:each) { command_handler.stub :handle_command }

      it "handles the greet command" do      
        client_socket.stub(:gets).and_return("greet")
        CommandHandlers::GreetCommandHandler.should_receive(:new)
          .and_return(command_handler)
        ClientHandler.new server, client_socket
      end

      it "handles the join command" do
        client_socket.stub(:gets).and_return("join")        
        CommandHandlers::JoinCommandHandler.should_receive(:new)
          .and_return(command_handler)
        ClientHandler.new server, client_socket
      end
    end

    context "given an invalid command" do
      before(:each) do
        client_socket.stub(:gets).and_return("unknown_command")
      end
      
      it "sends the error message to the client" do
        client_socket.should_receive(:puts)
          .with(/Command not supported: unknown_command/)
        server.stub(:puts)
        ClientHandler.new server, client_socket
      end

      it "sends the error message to the server" do
        client_socket.stub(:puts)
        server.should_receive(:puts)
          .with(/Command not supported: unknown_command/)
        ClientHandler.new server, client_socket
      end
    end
  end
end