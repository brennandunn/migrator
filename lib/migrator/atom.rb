class Migrator
  class Atom
    class << self
      
      def depends_on(*migrations)
        @dependencies ||= []
        @dependencies +=  migrations
      end
      
      def dependencies
        @dependencies ||= []
      end
      
      def up
      end
      
      def down
      end
      
    end
  end
end