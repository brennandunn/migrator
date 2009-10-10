class Migrator
  
  class Generator
    attr_accessor :options, :directory
    
    def initialize(*args)
      self.options = Options.new(args)
      options[:directory] ||= Dir.pwd
      
      create_rakefile
      create_db_directory
      create_dotfile
    end
    
    
    private
    
    def create_rakefile
      rakefile = File.join(File.dirname(__FILE__), 'generator', 'Rakefile')
      FileUtils.cp(rakefile, options[:directory])
    end
    
    def create_db_directory
      db_directory = File.join(options[:directory], 'db')
      unless File.exists?(db_directory) || File.directory?(db_directory)
        FileUtils.mkdir db_directory
      else
        puts %|The database directory already exists. Leaving it alone.|
      end
    end
    
    def create_dotfile
      dotfile     = File.join(File.dirname(__FILE__), 'generator', '.migrator')
      destination = File.join(options[:directory], '.migrator')
      unless File.exists?(destination)
        FileUtils.cp(dotfile, options[:directory])
      else
        puts %|The .migrator dotfile already exists. Leaving it alone.|
      end
    end
    
  end
  
  class Options < Hash
    
    def initialize(args)
      @opts = OptionParser.new do |o|
        o.on('--directory [DIRECTORY]', 'the directory with which to expand migrator') do |directory|
          self[:directory] = directory
        end
      end
      
      begin
        @opts.parse!(args)
      rescue OptionParser::InvalidOption => e
        self[:invalid_argument] = e.message
      end
    end
    
  end
  
end