Feature: In order to authenticate with a kubernetes cluster
  As an authorized technician
  I can obtain a token that will grant the access I need

  Scenario: Upstream IDP
    When I request a new token
    Then I am directed to an upstream identity provider

  Scenario: Authorized
    Given I am an authorized technician
    And I have already requested a new token
    When I prove my identity
    Then I receive a token that will work for kubernetes

  Scenario: Unauthorized
    Given I am not an authorized technician
    And I have already requested a new token
    When I prove my identity
    Then I do not receive a token
