Given /^a working directory$/ do
  @working_dir = File.join(MIGRATOR_ROOT, 'tmp')
  FileUtils.rm_rf @working_dir
  FileUtils.mkdir_p @working_dir
end

Then /^a file named "([^\"]*)" is created$/ do |file|
  file = File.join(@working_dir, file)

  assert File.exists?(file), "#{file} expected to exist, but did not"
  assert File.file?(file), "#{file} expected to be a file, but is not"
end

Given /^"([^"]+)" does not exist$/ do |file|
  assert ! File.exists?(File.join(@working_dir, file))
end

Given /^I create "([^\"]*)" with "([^\"]*)"$/ do |file, contents|
  File.open(File.join(@working_dir, file), 'w') { |f| f.write contents }
end

Then /^"([^\"]*)" contains "([^\"]*)"$/ do |file, string|
  contents = File.open(File.join(@working_dir, file), 'r') { |f| f.read }
  assert_match Regexp.new(string), contents
end

Given /^there is a Rakefile$/ do
  Given %|a file named "Rakefile" is created|
end

Given /^there is no Rakefile$/ do
  Given %|"Rakefile" does not exist|
end

Then /^I'm told that "([^\"]*)"$/ do |output|
  assert_match Regexp.new(output, 'i'), @stdout
end