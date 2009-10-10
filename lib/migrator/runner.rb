class Migrator
  
  class Proxy
    attr_reader :reference, :migration, :downscored_name
    
    delegate :name, :dependencies, :to => :migration
    
    def initialize(reference, file)
      @reference = reference
      load(file)
      @downscored_name = file.scan(/\/db\/(.*)\.rb/).flatten.first
      @migration = @downscored_name.camelize.constantize
    end
    
    def up
      invoke_dependencies
      @migration.up
    end
    
    def to_yaml
      { @migration.name => Time.now }
    end
    
    
    private
    
    def invoke_dependencies
      dependencies.each do |klass|
        proxy = reference.proxy_for_class(klass)
        reference.run_migration(proxy)
      end
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
      (migration_tree_with_scope - applied_migrations).each { |m| run_migration(m) }
      persist
    end
    
    def down!
      
    end
    
    def run_migration(proxy)
      proxy.up
      record(proxy)
    end
    
    def proxy_for_class(klass)
      migration_tree.detect { |m| m.migration == klass }
    end
    
    
    private
    
    def migration_tree
      @migration_tree ||= begin
        migrations = Dir.glob(File.join(directory, '**', '*.rb')).map { |f| Proxy.new(self, f) }
      end
    end
    
    def migration_tree_with_scope
      migration_tree.select { |m| options[:scope].include?(m.downscored_name) } if options[:scope].present?
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