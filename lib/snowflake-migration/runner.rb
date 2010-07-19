module Snowflake
  module Migration
    module Runner
      def migrations
        @migrations ||= []
      end

      def migration(title, version, *elements, &block)
        migrations << ::Snowflake::Migration::Context.new( title, version, elements, &block )
      rescue StandardError => e
        # @todo try and report syntax errors in a friendly fashion
        raise e
      end

      def migrate_up!
        migrations.sort {|migration1, migration2| migration1.version <=> migration2.version }.each { |migration| migration.up! }
      rescue StandardError => e
        # @todo report it
        raise e
      end

      def migrate_down!
        migrations.sort {|migration1, migration2| migration1.version <=> migration2.version }.each {|migration| migration.down! }
      rescue StandardError => e
        # @todo report it
        raise e
      end
    end # module Runner
  end # module Migration
end # module Snowflake

include Snowflake::Migration::Runner