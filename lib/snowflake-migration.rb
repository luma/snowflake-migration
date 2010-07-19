
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'snowflake'
require 'ostruct'
require 'logger'

module Snowflake
  module Migration
    class DuplicateMigrationError < SnowflakeError
    end

    dir = File.expand_path( '../snowflake-migration', __FILE__ )
    autoload :Migration,  dir + '/migration'
    autoload :Context,    dir + '/context'
    autoload :Schema,     dir + '/schema'

    def self.logger=(logger)
      @logger = logger
    end
    
    def self.logger
      @logger ||= begin
        log = Logger.new(STDOUT)
        log.level = Logger::INFO
        log
      end
    end
  end # module Migration
end # module Snowflake

dir = File.expand_path( '../snowflake-migration', __FILE__ )
require dir + '/version'
require dir + '/schemas'