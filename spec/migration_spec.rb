require 'spec_helper'

describe Snowflake::Migration::Migration do
  before :all do
    @migration = Snowflake::Migration::Migration.new( Company, '1', Time.now.to_i, "Test Migration", "It's a test!", [Company] )
  end

  it "returns a hash version of the migration" do
    @migration.to_hash.should == {
      'guid'           => @migration.guid,
      'timestamp'      => @migration.timestamp,
      'title'          => @migration.title,
      'description'    => @migration.description,
      'klasses'        => @migration.klasses.join(',')
    }
  end

  describe "===" do
    # it "should indicate when migrations are the same migration, against the same element (===)" do
    #   @migration.should === Snowflake::Migration::Migration.new( Company, '1', @migration.timestamp, "Test Migration", "It's a test!", [Company] )
    # end

    it "should indicate when migrations are the same migration, against the same element (==)" do
      @migration.should == Snowflake::Migration::Migration.new( Company, '1', @migration.timestamp, "Test Migration", "It's a test!", [Company] )
    end

    it "should not indicate that two migrations are the same when they have been applied to different elements" do
      @migration.should_not == Snowflake::Migration::Migration.new( String, '1', @migration.timestamp, "Test Migration", "It's a test!", [Company] )
    end

    it "should not indicate that two migrations are the same when they have different guids" do
      @migration.should_not == Snowflake::Migration::Migration.new( Company, 'bob', @migration.timestamp, "Test Migration", "It's a test!", [Company] )
    end

    it "should not indicate that two migrations are the same when they have different timestamps" do
      @migration.should_not == Snowflake::Migration::Migration.new( Company, '1', (Time.now + 1000).to_i, "Test Migration", "It's a test!", [Company] )
    end
  end

  describe "<=>" do
    it "should indicate a migration is before another when it has an earlier timestamp" do
      ( @migration.should < Snowflake::Migration::Migration.new( Company, '1', (Time.now + 10000).to_i, "Test Migration", "It's a test!", [Company] ) ).should be_true
    end

    it "should indicate a migration is after another when it has an later timestamp" do
      ( @migration.should > Snowflake::Migration::Migration.new( Company, '1', (Time.now - 10000).to_i, "Test Migration", "It's a test!", [Company] ) ).should be_true
    end
  end
end