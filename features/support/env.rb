require 'rings/runner'
require 'rings/server'

Before do
  @port = 5678  

  Thread.abort_on_exception = true
  
  @server_thread = Thread.start do
    @server = Rings::Server.new(@port) 
    @server.logger.level = Logger::ERROR
    Rings::Runner.run(@server)
  end
  
  @client = TCPSocket.open('localhost', @port)
end

After do
  @client.close
  @server.close
  @server_thread.kill
end
