
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'snowflake'
require 'ostruct'

module Snowflake
  module Migration

  end # module Migration
end # module Snowflake

dir = File.expand_path( '../snowflake-migration', __FILE__ )
require dir + '/version'
require dir + '/migration'
require dir + '/schema'
require dir + '/schemas'
require dir + '/context'

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

=end