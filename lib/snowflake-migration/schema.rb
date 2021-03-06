module Snowflake
  module Migration
    class Schema
      include Enumerable

      attr_reader :klass

      def initialize( klass )
        @klass = klass
        @migrations = nil
      end

      def length
        Snowflake.connection.zcard( klass.meta_key_for( 'schema' ) )
      end

      def include?( thing )
        version =  case thing
                when Integer, String
                  thing.to_s
                when Migration
                  thing.version
                else
                  raise ArgumentError, "Schema#include? accepts only Integers, Strings, or Migrations"
                end

        Snowflake.connection.zscore( klass.meta_key_for( 'schema' ), version ) != nil
      end

      def first
        each.first
      end

      def last
        each.last
      end

      def each
        load unless loaded?

        if block_given?
          @migrations.each do |migration|
            yield(migration)
          end
        end

        @migrations
      end

      def reload
        @migrations = nil
      end

      def <<(migration)
        # Fail if these are modified while we are attempt to add a migration -- we must be 
        # working on the newest data. The reason for this is that the data can be modified
        # between the #include? method call and the multi block.
        Snowflake.connection.watch( klass.meta_key_for( 'schema' ), klass.meta_key_for( 'schema', migration.version ) )

        if include?( migration.version )
          raise DuplicateMigrationError, "Migration #{migration.title} (#{migration.version}) has already been applied to #{self.class.to_s} and cannot be applied again."
        end

        result = Snowflake.connection.multi do |multi|
          multi.zadd( klass.meta_key_for( 'schema' ), migration.timestamp, migration.version )
          multi.hmset( *migration.to_hash.to_a.flatten.unshift( klass.meta_key_for( 'schema', migration.version ) ) )
        end

        # If the result is nil then the data was modified as we were trying to update it.
        if result == nil
          raise OutOfDateError, "The migration #{migration.title} (#{migration.version}) could not be added as the operation was interrupted by another update. Please try again."
        end

        reload
        self
      end

      def delete(migration)
        # @todo error check
        Snowflake.connection.multi do |multi|
          multi.zrem( klass.meta_key_for( 'schema' ), migration.version )
          multi.del( klass.meta_key_for( 'schema', migration.version ) )
        end
        
        reload
        self
      end

      def self.get( klass )
        self.new( klass )
      end

      private

      def loaded?
        @migrations != nil
      end

      def load
#        Snowflake.connection.watch( klass.meta_key_for( 'schema' ) )

        ids = Snowflake.connection.zrangebyscore( klass.meta_key_for( 'schema' ), "-inf", "+inf" )
        if ids.empty?
          @migrations = []
          return
        end

#        Snowflake.connection.watch( ids.collect {|id| klass.meta_key_for( 'schema', id ) } )

        @migrations = []
        
        ids.each do |id|
          migration_hash = Snowflake.connection.hgetall( klass.meta_key_for( 'schema', id ) )
          
          # @todo deal with potential nil value of migration_hash
          @migrations << Migration.from_hash( klass, migration_hash )
        end

      end

    end # class Schema
  end # module Migration
end # module Snowflake