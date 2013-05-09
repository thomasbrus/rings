Feature: Joining the server
  In order to play a game of Rings
  As a fanatic gamer
  I want to join the server

  Scenario: Joining the server using a valid nickname
    When I use the nickname "thomas_123"
    Then I should receive a message which indicates whether the server supports chat
    And I should receive a message which indicates whether the server supports challenge

  Scenario: Joining the server using an invalid nickname
    When I use the nickname "hello world"
    Then I should receive an error message

  Scenario: Joining the server when the nickname is already taken
    Given the nickname "thomas_123" is already taken
    When I use the nickname "thomas_123"
    Then I should receive a message which indicates that the nickname "thomas_123" is already taken

  Scenario: Joining the server twice
    Given I have joined the server using the nickname "thomas_123"
    When I use the nickname "thomas_456"
    Then I should receive an error message
