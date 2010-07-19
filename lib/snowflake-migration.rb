
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'snowflake'
require 'ostruct'

module Snowflake
  module Migration
    class DuplicateMigrationError < SnowflakeError
    end

    dir = File.expand_path( '../snowflake-migration', __FILE__ )
    autoload :Migration,  dir + '/migration'
    autoload :Context,    dir + '/context'
    autoload :Schema,     dir + '/schema'
  end # module Migration
end # module Snowflake

dir = File.expand_path( '../snowflake-migration', __FILE__ )
require dir + '/version'
require dir + '/schemas'