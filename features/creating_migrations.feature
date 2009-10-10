Feature: creating new migrations
  In order to create a new migration
  A user should be able to
  use the Rakefile 'add' task to create a migration
  
  Scenario: running the Rake task with no arguments
    Given a working directory
    And I have expanded migrator
    When I run the rake task "migration:add" with ""
    
    Then I'm told that migration added
    And a file named "db/new_migration.rb" is created
    And "db/new_migration.rb" contains "class NewMigration < Migrator::Atom"
  
  Scenario: running the Rake task with a name argument
    Given a working directory
    And I have expanded migrator
    When I run the rake task "migration:add" with "name=create_users_table"
    
    Then I'm told that migration added
    And a file named "db/create_users_table.rb" is created
    And "db/create_users_table.rb" contains "class CreateUsersTable < Migrator::Atom"
  
  Scenario: running the Rake task with a name argument that already exists
    Given a working directory
    And I have expanded migrator
    And I create "db/create_users_table.rb" with "class CreateUsersTable < Migrator::Atom ; end"
    When I run the rake task "migration:add" with "name=create_users_table"
    
    Then I'm told that migration exists for create_users_table