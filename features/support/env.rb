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

class CustomWorld
  def request_game(client, number_of_players)
    client.puts "request_game #{number_of_players}"
  end

  def join_server(client, nickname, chat_supported, challenge_supported)
    client.puts "join_server #{nickname} #{chat_supported ? 1 : 0} #{challenge_supported ? 1 : 0}"
  end
end

World do
  CustomWorld.new
end

