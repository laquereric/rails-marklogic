@quickstart @onboarding @smoke @quickstart_contracts
Feature: Full Quickstart smoke test

  @smoke
  Scenario: Walk the full Quickstart narrative
    Given a Rails application with ropencode-rails installed
    And a User model exists
    When I invoke ropencode
    And I run ropencode command "explain User"
    And I ask a question via ropencode
    Then I should remain inside IRB
    And I should get a response or an explanation
