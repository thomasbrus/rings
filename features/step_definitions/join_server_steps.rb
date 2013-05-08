When(/^I join the server (without using a nickname)|(using the nickname "(.+))"$/) do |_, _, nickname|
  chat_supported = 1
  challenge_supported = 1
  @client.puts "join_server #{nickname} #{chat_supported} #{challenge_supported}"
end
