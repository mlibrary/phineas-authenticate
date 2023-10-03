Feature: In order to authenticate with a kubernetes cluster
  As an authorized technician
  I can obtain a token that will grant the access I need

  Scenario:
    Given I am an authorized technician
    And I open this application
    When I request a new token
    Then I am directed to an upstream identity provider

  Scenario:
    Given I am an authorized technician
    And I have been directed to an upstream identity provider
    When I prove my identity
    Then I receive a token that will work for kubernetes
