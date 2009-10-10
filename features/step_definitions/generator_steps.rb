Given /^I have expanded migrator$/ do
  When "I expand migrator"
  Then "there is a Rakefile"
  And "a DB directory is created"
end

When /^I expand migrator$/ do
  @stdout = OutputCatcher.catch_out do
    args = ['--directory', @working_dir]
    Migrator::Generator.new(*args)
  end
end

Then /^a DB directory is created$/ do
  assert File.directory?(File.join(@working_dir, 'db')), 'Expected a DB directory be created'
end

Then /^a dotfile is created$/ do
  Then %|a file named ".migrator" is created|
end

Then /^the Rakefile is appended$/ do
  Then %|"Rakefile" contains "migrator"|
end

Given /^there is a DB directory$/ do
  FileUtils.mkdir File.join(@working_dir, 'db')
end

Given /^there is a dotfile$/ do
  FileUtils.touch File.join(@working_dir, '.migrator')
end

When /^I run the rake task "([^\"]*)" with "([^\"]*)"$/ do |task, env|
  keys_to_delete = []
  env.split(' ').each { |s| k,v = s.split('=') ; ENV[k] = v ; keys_to_delete << k }
  Migrator::Tasks.new(:path => @working_dir)
  Rake.application[task].reenable
  @stdout = OutputCatcher.catch_out do
    Rake.application[task].invoke
  end
  keys_to_delete.each { |k| ENV.delete(k) }
end

When /^I run the rake task "([^\"]*)"$/ do |task|
  When %|I run the rake task "#{task}" with ""|
end