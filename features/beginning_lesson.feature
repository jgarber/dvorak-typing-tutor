@javascript @focus
Feature: Learn the first keys
  In order to type faster
  By learning the Dvorak keyboard
  As a Dvorak keyboard novice
  I want to learn keys on the home row

  Background:
    Given I have the following practice script:
      """
      a
      at
      ha
      ah
      hat
      that
      hath
      eh
      tee
      the
      thee
      tea
      heat
      hate
      teeth
      theta
      heath
      """

  Scenario: Starting the lesson
    When I begin the lesson
    Then the timer should not be running
    And the input box should be blank
    And the voice should say "a"
    And the example loupe should say "a"

  Scenario: Typing the first characters
    Given I have begun the lesson
    When I type "a"
    Then the timer should be running
    And the input box should contain "a"
    When I press return
    Then the input box should be blank
    And the voice should say "at"
    And the example loupe should say "at"

  Scenario: Needing help finding a key
    When I begin the lesson
    And I hesitate
    Then the a key should be highlighted on the virtual keyboard
    And the voice should say "The a key is on the home row, under your left little finger."
    When I type "a"
    And I press return
    And I type "a"
    And I hesitate
    Then the t key should be highlighted on the virtual keyboard
    And the voice should say "The t key is on the home row, under your right middle finger."

  Scenario: Typing a wrong letter
    Given I have begun the lesson
    When I type "o"
    Then I should hear a warning beep
    And the input box should contain "o"
    And the "o" in the input box should be underlined
    And the example loupe should say "a"
    When I backspace
    And I type "a"
    Then the input box should contain "a"
    When I press return
    And the example loupe should say "at"
    And nothing in the input box should be underlined

  Scenario: Ending the lesson
    Given I have begun the lesson
    When I type "a"
    Then the timer should be running
    When I type all of the example text verbatim
    Then the timer should be stopped
    And the timer should show me my elapsed time
    And I should see my words per minute
