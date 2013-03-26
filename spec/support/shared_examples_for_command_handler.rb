shared_examples_for CommandHandler do
  it { described_class.should respond_to :command }

  let(:server) { double :server }
  let(:client) { double :client }
  let(:client_handler) { double :client_handler }

  before(:each) do
    server.stub(:name_taken?)
    server.stub(:chat_supported?).and_return true
    server.stub(:challenge_supported?).and_return true
    
    client.stub(:name=)
    client.stub(:chat_supported=)
    client.stub(:challenge_supported=)
    client.stub(:puts)
    
    client_handler.stub(:server) { server }
    client_handler.stub(:client) { client }
  end  
end