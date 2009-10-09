Given /^I have expanded migrator$/ do
  pending
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

Then /^the Rakefile is appended$/ do
  Then %|"Rakefile" contains "migrator"|
end

Given /^there is a DB directory$/ do
  FileUtils.mkdir File.join(@working_dir, 'db')
end