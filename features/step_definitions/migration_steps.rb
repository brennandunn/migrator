Given /^a migration exists named "([^\"]*)" containing:$/ do |file, contents|
  File.open(File.join(@working_dir, 'db', file + '.rb'), 'w') { |f| f.write contents }
end

Then /^the migrator dotfile contains "([^\"]*)"$/ do |string|
  Then %|".migrator" contains "#{string}"|
end

Then /^(.*) runs (.*)$/ do |migration, dependency|
  migration, dependency = migration.constantize, dependency.constantize
end
