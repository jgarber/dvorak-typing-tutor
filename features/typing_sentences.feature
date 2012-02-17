@javascript
Feature: Practice typing sentences
  In order to improve my typing speed
  As a Dvorak keyboard learner
  I want to practice typing full sentences

  Background:
    Given I have the following lesson script:
      """
      It is a truth| universally acknowledged,| that a single man| in possession| of a good fortune,| must be| in want of a wife.
      """

  Scenario: Starting the lesson
    When I begin the lesson
    Then the timer should not be running
    And the input box should be blank
    And the voice should say "It is a truth"
    And the example loupe should say "It is a truth"

  Scenario: Typing the first lesson
    Given I have begun the lesson
    When I type "I"
    Then the timer should be running
    When I type "t is a truth"
    Then the input box should contain "It is a truth"
    When I press return
    Then the voice should say " universally acknowledged,"
    And the example loupe should say " universally acknowledged,"

  Scenario: Needing brief help finding a key
    When I begin the lesson
    And I type "It is a t"
    And I hesitate
    Then the r key should be highlighted on the virtual keyboard
    And the voice should say "The r key is right hand, top row, ring finger, no rich."
    When I type "ruth"
    When I press return
    When I type " "
    And I hesitate
    Then the u key should be highlighted on the virtual keyboard
    And the voice should say "The u key is left hand, home row, index finger, no rich."
    When I type "universally ac"
    And I hesitate
    Then the k key should be highlighted on the virtual keyboard
    And the voice should say "The k key is left hand, bottom row, index finger, no rich."

  Scenario: Misspell a word
    Given I have begun the lesson
    When I type "It in"
    Then I should hear a warning beep
    And the input box should contain "It in"
    And the "in" in the input box should be underlined
    When I backspace
    And I type "s"
    Then the input box should contain "It is"
    And nothing in the input box should be underlined
