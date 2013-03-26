shared_examples_for CommandHandler do
  let(:server) { double :server }
  let(:client_socket) { double :client_socket }
  let(:client_handler) { double :client_handler }

  before(:each) do
    server.stub(:name_taken?).and_return(false)
    server.stub(:chat_supported?).and_return(true)
    server.stub(:challenge_supported?).and_return(true)
    
    client_socket.stub(:name=)
    client_socket.stub(:chat_supported=)
    client_socket.stub(:challenge_supported=)
    # client_socket.stub(:puts)
    
    client_handler.stub(:server) { server }
    client_handler.stub(:client_socket) { client_socket }
  end
  
  subject { described_class.new client_handler }
  specify { described_class.should respond_to :command }
end