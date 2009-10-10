require 'rake'
require 'rake/tasklib'
require 'activesupport'
require 'activerecord'
require 'migrator/generator'
require 'migrator/tasks'
require 'migrator/runner'
require 'migrator/atom'

class Migrator
  attr_accessor :directory
  
  def initialize(options = {})
    self.directory = options[:path] || Dir.pwd
  end
  
  def run(options = {})
    Runner.new(directory, options).up!
  end
  
  def create_migration(path)
    klass_file = (path || 'new_migration') + '.rb'
    file = File.join(directory, 'db', klass_file)
    return false if File.exists?(file)
    
    File.open(file, 'w') do |f|
      f.write <<-EOS
class #{File.basename(klass_file, '.rb').camelize} < Migrator::Atom
  
end
EOS
    end
  end
  
end