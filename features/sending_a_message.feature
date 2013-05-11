Feature: Sending a message
  In order to communicate with other players
  As a social gamer
  I want to send chat messages

  Scenario: Sending a message without joining the server
    When I send the message "Hello world."
    Then I should receive an error message

  Scenario: Sending a message while not in game
    Given I have joined the server
    When I send the message "Hello world."
    Then I should receive an error message

  Scenario: Send a message while in game
    Given I am in a four player game, with two players that support chat
    When I send the message "Hello world."
    Then everyone that supports chat should receive my message
