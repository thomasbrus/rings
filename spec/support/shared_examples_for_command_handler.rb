shared_examples_for CommandHandler do
  let(:server) { double :server }
  let(:client_socket) { double :client_socket }
  let(:session) { double :session }

  before(:each) do
    server.stub(:nickname_taken?).and_return(false)
    server.stub(:chat_supported?).and_return(true)
    server.stub(:challenge_supported?).and_return(true)
    
    client_socket.stub(:nickname=)
    client_socket.stub(:game=)
    client_socket.stub(:chat_supported=)
    client_socket.stub(:challenge_supported=)
    client_socket.stub(:puts)
    
    session.stub(:server) { server }
    session.stub(:client_socket) { client_socket }
  end
  
  specify { described_class.should respond_to :command }
end