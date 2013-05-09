Given(/^someone has requested a two player game$/) do
  client = TCPSocket.open('localhost', @port)
  join_server(client, "someone", true, true)
  request_game(client, 2)
end

When(/^I request a game for (\d+) players?$/) do |number_of_players|
  request_game(@client, number_of_players)
end

Then(/a game for two players should be started/) do
  @client.gets.should match(/start_two_player_game/)
end

def request_game(client, number_of_players)
  client.puts "request_game #{number_of_players}"
end