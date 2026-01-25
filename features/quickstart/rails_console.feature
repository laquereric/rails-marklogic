@quickstart @onboarding @rails_console @quickstart_contracts
Feature: Rails console quickstart

  @quickstart
  Scenario: Enter enhanced console
    Given a Rails application with ropencode-rails installed
    When I invoke ropencode
    Then I should remain inside IRB

  @quickstart
  Scenario: Explain a model
    Given a User model exists
    When I run ropencode command "explain User"
    Then I should see model information

  @quickstart
  Scenario: Recover from invalid command
    When I run ropencode command "bogus"
    Then I should see an error explanation
    And I should remain inside IRB
