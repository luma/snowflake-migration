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

=begin


17. Migrations. Just because we are schemaless on the DB side doesn't mean evolving data needs won't affect us. Create a Schema model, each element should have one.
		We store at least:
			In %element_class_name%::schema::%guid% (SORTED SET)	=>
				ZADD element_class_name::schema %timestamp% "%guid%"
				ZADD element_class_name::schema %timestamp% "%guid%"
				ZADD element_class_name::schema %timestamp% "%guid%"
				ZADD element_class_name::schema %timestamp% "%guid%"

  In %element_class_name%::schema::%guid%	{id: %guid%, timestamp:%timestamp%, title:%title%, description:%description%}

	e.g. Company.schema.first => {id: %guid%, timestamp:%timestamp%, title:%title%, description:%description%, up:%up%, down:%down%}
			 Company.schema.automigrate
   		 Company.schema.migrate_to(%guid%)
   		 Company.schema.difference(%guid1%, %guid2%)

		Then rake scripts to do common migration tasks and a dsl to write the actual migrations. Add "schema" as a restricted Attribute name.

ZADD element_class_name::schema 1278461960 1
ZADD element_class_name::schema 1278548360 2
ZADD element_class_name::schema 1278634760 3
ZADD element_class_name::schema 1278721160 4

ZRANGE element_class_name::schema 0 -1
=end