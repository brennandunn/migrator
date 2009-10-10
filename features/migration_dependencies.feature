@wip
Feature: ensuring migrations are run in proper order
  In order to run a one or many migrations
  A user should understand that 
  dependencies exists within migrations, and these 
  must be met before some migrations can be run
  
  Scenario: a migration with no dependencies
    Given a working directory
    And I have expanded migrator
    And a migration exists named "create_users" containing:
      """
      class CreateUsers < Migrator::Atom
        
      end
      """
    When I run the rake task "migration:run" with "files=create_users"
    Then the migrator dotfile contains "CreateUsers"
  
  Scenario: a migration with one dependency, which hasn't been run
    Given a working directory
    And I have expanded migrator
    And a migration exists named "create_users" containing:
      """
      class CreateUsers < Migrator::Atom
      
      end
      """
    And a migration exists named "alter_users" containing:
      """
      class AlterUsers < Migrator::Atom
        depends_on CreateUsers
      end
      """
    When I run the rake task "migration:run" with "files=alter_users"
    Then AlterUsers runs CreateUsers
    And the migrator dotfile contains "CreateUsers"
    And the migrator dotfile contains "AlterUsers"
