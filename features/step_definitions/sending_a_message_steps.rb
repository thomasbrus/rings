require 'uri'

When(/^I send the message "(.+)"$/) do |message|
  send_message(@client, message)
  @message = message
end

Given(/^I am in a four player game, with two players that support chat$/) do
  @clients = [@client] + 3.times.map { TCPSocket.open('localhost', @port) }

  join_server(@clients[0], @nickname, true, true)
  join_server(@clients[1], "client_1", true, true)
  join_server(@clients[2], "client_2", false, true)
  join_server(@clients[3], "client_3", false, true)
 
  @clients.map { |client| request_game(client, 4) }
  @clients.map { |client| 3.times { client.gets } }
end

Then(/^everyone that supports chat should receive my message$/) do
  @clients[0].gets.should match(/add_message #{@nickname} #{URI.encode(@message)}/)
  @clients[1].gets.should match(/add_message #{@nickname} #{URI.encode(@message)}/)
end
