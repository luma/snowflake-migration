module Snowflake
  module Migration
    class Migration
      attr_reader :klass, :guid, :timestamp, :title, :description, :klasses

      def initialize(klass, guid, timestamp, title, description, klasses)
        @klass = klass
        @guid = guid
        @klasses = klasses
        @timestamp = timestamp.to_i
        @title = title
        @description = description
      end

      def to_hash
        {
          'guid'           => @guid,
          'timestamp'     => @timestamp,
          'title'          => @title,
          'description'    => @description,
          'klasses'        => @klasses.join(',')
        }
      end

      # Comparing objects inside a 'case' statement
      # def ===(other)
      #   @klass == other.klass && @guid == other.guid && @timestamp == other.timestamp
      # end

      def ==(other)
        @klass == other.klass && @guid == other.guid && @timestamp == other.timestamp
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
        Migration.new( klass, hash['guid'], hash['timestamp'], hash['title'], hash['description'], hash['klasses'].split(',') )
      end
    end # class Migration
  end # module Migration
end # module Snowflake