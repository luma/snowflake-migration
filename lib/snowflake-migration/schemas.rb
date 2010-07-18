module Snowflake
  module Migration
    module Schemas
      ::Snowflake::Element::Model.add_extensions self

      # Retrieves the schema info for this element.
      #
      # @return [Schema]
      #   the created Attribute
      #
      # @api public    
      def schema
        Schema.get( self )
      end

    end # module Schemas
  end # module Migration
end # module Snowflake