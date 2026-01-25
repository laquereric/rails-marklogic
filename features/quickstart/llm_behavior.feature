@quickstart @onboarding @llm_defaults @quickstart_contracts
Feature: LLM quickstart behavior

  @quickstart
  Scenario: Local LLM available by default
    Given no LLM credentials are configured
    When I ask a question via ropencode
    Then I should get a response or an explanation

  @quickstart
  Scenario: Policy violation is explained
    When I issue a policy-violating request
    Then I should see a policy explanation
    And I should remain inside IRB
