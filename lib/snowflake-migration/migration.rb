module Snowflake
  module Migration
    class Migration
      attr_reader :klass, :version, :timestamp, :title, :description, :klasses

      def initialize(klass, version, timestamp, title, description, klasses)
        @klass = klass
        @version = version
        @klasses = klasses
        @timestamp = timestamp.to_i
        @title = title
        @description = description
      end

      def to_hash
        {
          'version'           => @version,
          'timestamp'     => @timestamp,
          'title'          => @title,
          'description'    => @description,
          'klasses'        => @klasses.join(',')
        }
      end

      # Comparing objects inside a 'case' statement
      # def ===(other)
      #   @klass == other.klass && @version == other.version && @timestamp == other.timestamp
      # end

      def ==(other)
        @klass == other.klass && @version == other.version && @timestamp == other.timestamp
      end

      # Comparing objects
      def <=>(other)
        @timestamp <=> other.timestamp
      end
      
      def >(other)
        @timestamp > other.timestamp
      end

      def >=(other)
        @timestamp >= other.timestamp
      end

      def <(other)
        @timestamp < other.timestamp
      end

      def <=(other)
        @timestamp <= other.timestamp
      end

      def self.from_hash( klass, hash )
        Migration.new( klass, hash['version'], hash['timestamp'], hash['title'], hash['description'], hash['klasses'].split(',') )
      end
    end # class Migration
  end # module Migration
end # module Snowflake