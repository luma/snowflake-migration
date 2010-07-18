require 'rubygems'
require 'snowflake'
require 'snowflake-migration'

if RUBY_VERSION > '1.9.0'
	require 'ruby-debug'
else
	require "ruby-debug"
end

class Messages
  def self.<<(message)
    messages << message
  end

  def self.messages
    @messages ||= []
  end

  def self.dump
    puts @messages.inspect
  end
end


class Company
  include Snowflake::Node

  attribute :name,         String, :key => true
  attribute :description,  String
  attribute :enabled,      ::Snowflake::Attributes::Boolean

  validates_presence_of :name
end

class Staff
  include Snowflake::Node

  attribute :name,         String, :key => true
  attribute :age,          Integer
  attribute :mood,         String
  attribute :description,  String
  attribute :enabled,      ::Snowflake::Attributes::Boolean

#  counter :visits      # <-- native Redis Counter
#  set :tags            # <-- native Redis Set
#  list :awards         # <-- native Redis List
  # @TODO: Hash

  validates_presence_of :name
end

Snowflake.connect
Snowflake.flush_db

require 'snowflake-migration/runner'