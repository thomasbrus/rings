require_relative '../../rings/runner'
require_relative '../../rings/server'
require_relative 'uri'

Thread.abort_on_exception = true

Before do
  @client.close unless @client.nil?
  @server.close unless @server.nil?
  @server_thread.kill unless @server_thread.nil?

  @port = 5678
  @nickname = "thomasbrus"

  @server_thread = Thread.start do
    @server = Rings::Server.new(@port)
    # @server.logger.level = Logger::ERROR
    Rings::Runner.run(@server)
  end

  @client = TCPSocket.open('localhost', @port)
end

After do
  # puts "Shutting down things" 
end

class CustomWorld
  def request_game(client, number_of_players)
    client.puts "request_game #{number_of_players}"
  end

  def join_server(client, nickname, chat_supported, challenge_supported)
    client.puts "join_server #{nickname} #{chat_supported ? 1 : 0} #{challenge_supported ? 1 : 0}"
  end

  def send_message(client, message)
    client.puts "send_message #{URI.encode(message)}"
  end
end

World do
  CustomWorld.new
end
