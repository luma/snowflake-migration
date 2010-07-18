require "bundler"
Bundler.setup

require "spec"
require "snowflake"
require "snowflake-migration"


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
  
  def self.clear
    messages.clear
  end
end

Spec::Runner.configure do |config|
  config.mock_with :mocha

  config.after :each do
    Snowflake.connect
    
    10.times do |i|
      Company.create :name => "company #{i}", :enabled => true, :description => 'asdf'
      Staff.create :name => "bob #{i}", :age => (10 + i * 5).years.ago, :enabled => true, :description => 'asdf'
    end
  end
end