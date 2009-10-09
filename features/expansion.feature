Feature: expanding into a project
  In order to add migration support
  A user should be able to
  create migrator directory structure
  
  Scenario: creating a Rakefile when one doesn't exist
    Given a working directory
    And there is no Rakefile
    When I expand migrator
    
    Then there is a Rakefile
    And a DB directory is created
  
  @wip
  Scenario: creating a Rakefile when one exists already
    Given a working directory
    And I create "Rakefile" with ""
    When I expand migrator
    
    Then the Rakefile is appended
    And a DB directory is created
  
  Scenario: attempting to create a DB directory when one exists
    Given a working directory
    And there is a DB directory
    When I expand migrator
    
    Then I'm told that "database directory already exists"