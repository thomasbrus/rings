Then(/^I should see an error message$/) do
  @client.gets.should =~ /error/
end

Then(/^I should not see an error message$/) do  
  @client.gets.should_not =~ /error/
end
