Feature: Requesting a game
  In order to play a game of rings
  As a fanatic gamer
  I want to request a game

  Scenario: Requesting a game without joining the server
    When I request a game for 2 players
    Then I should receive an error message  

  Scenario: Requesting a two player game
    Given I have joined the server
    And someone has requested a two player game
    When I request a game for 2 players 
    Then a game for two players should be started

  Scenario: Requesting a game for too many players
    Given I have joined the server
    When I request a game for 8 players
    Then I should receive an error message

  Scenario: Requesting a game for too few players
    Given I have joined the server
    When I request a game for 1 player
    Then I should receive an error message 
  