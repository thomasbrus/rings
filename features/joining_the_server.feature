Feature: Joining the server
  In order to take on an identity
  As a fanatic gamer
  I want to join the server

  Scenario: Joining the server using a valid nickname
    When I use the nickname "thomasbrus"
    Then I should receive a message which indicates whether the server supports chat
    And I should receive a message which indicates whether the server supports challenge

  Scenario: Joining the server using an invalid nickname
    When I use the nickname "thomas brus"
    Then I should receive an error message

  Scenario: Joining the server when the nickname is already taken
    Given the nickname "thomasbrus" is already taken
    When I use the nickname "thomasbrus"
    Then I should receive a message which indicates that the nickname "thomasbrus" is already taken

  # Scenario: Joining the server twice
  #   Given I have joined the server using the nickname "thomasbrus"
  #   When I use the nickname "superman"
  #   Then I should receive an error message

