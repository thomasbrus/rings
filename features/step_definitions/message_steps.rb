Then(/^I should receive an error message$/) do
  @client.gets.should match(/error/i)
end
