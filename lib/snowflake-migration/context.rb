module Snowflake
  module Migration
    class Context
      attr_reader :title, :version, :timestamp, :elements
      def initialize(title, version, elements, &block)
        @title = title
        @version = version
        @timestamp = nil
        @elements = elements

        @up = lambda {}
        @down = lambda {}

        instance_eval &block
      end

      # Indicates if the migration has been applied to even one of the elements.
      def applied?
        @elements.each do |element|
          if element.schema.include?( @version )
            return true
          end
        end

        false
      end

      # @todo On errors we should handle, cleanup, and then reraise...
      def up!
        Snowflake::Migration.logger.info "Applying migration #{@title} (#{@version}) on: #{@elements.join(', ')}"

        if applied?
          raise DuplicateMigrationError, "Migration \"#{@title}\" (#{@version}) has already been applied to one or more of the target elements (#{applied_to.collect {|e| e.to_s }.join(', ')}) and cannot be applied again."
        end

        begin
          result = @up.call
        rescue StandardError => e
          # @todo do some error handling
          raise e
        end

        # @todo check result?

        @timestamp = Time.now.utc.to_i
        @elements.each do |element|
          element.schema << Migration.new(element, @version, @timestamp, @title, @description, @elements)
        end

        true
      end

      # @todo I don't think I've thought through undoing migrations particularly well, more thought needed...
      # @todo On errors we should handle, cleanup, and then reraise...
      def down!
        Snowflake::Migration.logger.info "Undoing migration #{@title} (#{@version}) on: #{@elements.join(', ')}"

        unless applied?
          raise ArgumentError, "Migration \"#{@title}\" (#{@version}) has not been applied to one or more of the target elements (#{(@elements - applied_to).collect {|e| e.to_s }.join(', ')}) and therefore cannot be revert."
        end

        begin
          result = @down.call
        rescue StandardError => e
          # @todo do some error handling
          raise e
        end

        # @todo undo the migration
        @timestamp = nil
        @elements.each do |element|
          element.schema.delete( Migration.new(element, @version, @timestamp, @title, @description, @elements) )
        end
      end

      def description(text = nil)
        @description = block_given? ? yield : text
      end

      def up(&block)
        @up = block
      end

      def down(&block)
        @down = block
      end
      
      private
      
      def applied_to
        @elements.delete_if do |element|
          !element.schema.include?( @version )
        end        
      end
    end # class Context
  end # module Migration
end # module Snowflake