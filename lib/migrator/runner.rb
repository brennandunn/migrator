class Migrator
  
  class Proxy
    attr_reader :migration
    
    delegate :up, :down, :to => :migration
    
    def initialize(reference, file)
      @reference = reference
      load(file)
      @name = file.scan(/#{Regexp.new(reference.directory)}\/db\/(.*)\.rb/).flatten.first
      @migration = @name.camelize.constantize
    end
    
    def to_yaml
      { Time.now.to_i => { :name => @migration.name } }
    end
    
  end
  
  class Runner
    attr_reader :directory, :options
    attr_reader :queue
    
    def initialize(directory, options = {})
      @directory, @options = directory, options
      @io = File.open(File.join(directory, '.migrator'), 'r') { |f| YAML::load(f) }
    end
    
    def up!
      @queue = migration_tree
      @queue.each { |m| m.up ; record(m) }
      persist
    end
    
    def down!
      
    end
    
    
    private
    
    def migration_tree
      @tree ||= begin
        files = Dir.glob(File.join(directory, '**', '*.rb'))
        files.map { |f| Proxy.new(self, f) }
      end
    end
    
    def record(migration)
      @io['migrations'] << migration.to_yaml
    end
    
    def persist
      File.open(File.join(directory, '.migrator'), 'w') { |f| YAML::dump(@io, f) }
    end
    
  end
end