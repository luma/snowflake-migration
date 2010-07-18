require 'spec_helper'

describe "Snowflake::Migration::Runner" do
  before :all do
    Snowflake.flush_db

    require 'snowflake-migration/runner'

    migration "Simple Migration Example", 1, Company do
      description "An simple example migration"

      up do
        puts "Simple Migration Example: Up"
        Messages << "Simple Migration Example: Up"
      end

      down do
        Messages << "Simple Migration Example: Down"
      end		
    end

    Messages.clear
    migrate_up!
    Messages.dump
  end

  describe "Up" do
    it "should have executed the up block" do
      Messages.messages.should include("Simple Migration Example: Up")
    end

    describe "Schema" do
      it "creates a migration in the element schema" do
        Company.schema.length.should == 1
      end

      it "creates a migration with the correct guid" do
        Company.schema.first.guid.should == '1'
      end

      it "creates a migration with the correct title" do
        Company.schema.first.title.should == "Simple Migration Example"
      end

      it "creates a migration with the correct description" do
        Company.schema.first.description.should == "An simple example migration"
      end

      it "creates a migration with the correct klasses" do
        Company.schema.first.klasses.should == ['Company']
      end
    end
  end

  describe "Down" do
    before (:all) do
      Messages.clear
      migrate_down!
      Messages.dump
    end

    it "should have executed the down block" do
      Messages.messages.should include("Simple Migration Example: Down")
    end

    describe "Schema" do
      it "destroys the existing schemas" do
        Company.schema.length.should == 0
      end
    end
  end


end