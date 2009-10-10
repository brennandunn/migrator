class Migrator
  
  class Proxy
    attr_reader :migration
    
    delegate :up, :down, :name, :to => :migration
    
    def initialize(file)
      load(file)
      @name = file.scan(/\/db\/(.*)\.rb/).flatten.first
      @migration = @name.camelize.constantize
    end
    
    def to_yaml
      { @migration.name => Time.now }
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
      (migration_tree - applied_migrations).each { |m| m.up ; record(m) }
      persist
    end
    
    def down!
      
    end
    
    
    private
    
    def migration_tree
      @migration_tree ||= Dir.glob(File.join(directory, '**', '*.rb')).map { |f| Proxy.new(f) }
    end
    
    def applied_migrations
      migration_tree.select { |m| @io['migrations'].map(&:keys).flatten.include?(m.name) }
    end
    
    def record(migration)
      @io['migrations'] << migration.to_yaml
    end
    
    def persist
      File.open(File.join(directory, '.migrator'), 'w+') { |f| YAML::dump(@io, f) }
    end
    
  end
end