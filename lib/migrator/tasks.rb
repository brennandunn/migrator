class Migrator
  class Tasks < ::Rake::TaskLib
    attr_accessor :instance
    
    def initialize(options = {})
      self.instance = Migrator.new(options)
      setup
    end
    
    
    private
    
    def setup
      
      namespace :migration do
        
        desc "Add a new migration."
        task :add do
          path = ENV['name']
          if file = instance.create_migration(path)
            $stdout.puts "Migration added: #{file}"
          else
            $stdout.puts "Migration exists for #{path}"
          end
        end
        
        desc "Run the migrations."
        task :run do
          scope = ENV['files'].split(',').map(&:strip) if ENV['files']
          instance.run(:scope => scope)
        end
        
      end
      
    end
    
  end
end