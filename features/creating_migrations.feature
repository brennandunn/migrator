Feature: creating new migrations
  In order to create a new migration
  A user should be able to
  use the Rakefile to create a migration
  
  Scenario: running the Rake "add" task with no arguments
    Given a working directory
    And I have expanded migrator
    When I run "rake migration:add"
    
    Then a file named "db/new_migration.rb" is created
    And "db/new_migration.rb" contains "class NewMigration < Migration"
  
  Scenario: running the Rake "add" task with a name argument
    Given a working directory
    And I have expanded migrator
    When I run "rake migration:add name=create_users_table"
    
    Then a file named "db/create_users_table.rb" is created
    And "db/create_users_table.rb" contains "class CreateUsersTable < Migration"