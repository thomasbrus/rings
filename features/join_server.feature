Feature: Joining the server
  In order to play a game of Rings
  As a fanatic gamer
  I want to join the server

  Scenario: Joining the server using a valid nickname
    When I join the server using the nickname "thomas_123"
    Then I should not see an error message

  Scenario: Joining the server without using a nickname
    When I join the server without using a nickname
    Then I should see an error message

  Scenario: Joining the server using an invalid nickname
    When I join the server using the nickname "hello world"
    Then I should see an error message
