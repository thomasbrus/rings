require 'uri'

Given(/^I have joined the server$/) do
  step %[I have joined the server using the nickname "#{@nickname}"]
end

Given(/^I have joined the server using the nickname "(.+)"$/) do |nickname|
  step %[I use the nickname "#{nickname}"]
  step %[I should receive a message which indicates whether the server supports chat]
  step %[I should receive a message which indicates whether the server supports challenge]
end

When(/^I use the nickname "(.+)"$/) do |nickname|
  join_server(@client, nickname, true, true)
end

Then(/^I should receive a message which indicates whether the server supports (chat|challenge)$/) do |capability|
  @client.gets.should match(/notify_#{capability}_support (0|1)/i)
end

Given(/^the nickname "(.+)" is already taken$/) do |nickname|
  client = TCPSocket.open('localhost', @port)
  puts "Issueing join server command"
  join_server(client, nickname, true, true)
  client.close
end

Then(/^I should receive a message which indicates that the nickname "(.+)" is already taken$/) do |nickname|
  message = URI.encode(%[nickname "#{nickname}" is already taken])
  @client.gets.should match(/#{message}/i)
end
