require 'spec_helper'

describe Snowflake::Migration::Schemas do
  before :all do
    Snowflake.flush_db

    @migration = Snowflake::Migration::Migration.new(Company, '1', Time.now.to_i, "Test Migration", "Description for Test Migration", ["Company"])
    Company.schema << @migration
  end

  describe "#<<" do
    it "adds migrations to the schema" do
      Company.schema.should include('1')
      Company.schema.first.should == @migration
    end
    
    it "persists migrations to the db" do
      Snowflake.connection.zrangebyscore( Company.meta_key_for( 'schema' ), "-inf", "+inf" ).should == [@migration.version]
      Snowflake.connection.hgetall( Company.meta_key_for( 'schema', @migration.version ) ).should == @migration.to_hash.merge('timestamp' => @migration.timestamp.to_s)
    end
  end
end