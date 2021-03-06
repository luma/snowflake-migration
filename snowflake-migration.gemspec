require File.expand_path("../lib/snowflake-migration/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "snowflake-migration"
  s.version     = Snowflake::Migration::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rolly Fordham"]
  s.email       = ["rolly@luma.co.nz"]
  s.homepage    = "http://github.com/luma/snowflake-migration"
  s.summary     = "A gem to add schema change management (migrations) to Snowflake."
  s.description = "This gem adds schema change management to Snowflake (http://github.com/luma/snowflake), including migrations and the ability to track schema changes within models over time."

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "snowflake-migration"

  # If you have other dependencies, add them here
  s.add_dependency "snowflake", "~> 0.2.13"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/snowflake-migration.rb", "{lib}/snowflake-migration/*.rb", "LICENSE", "*.md", "README.rdoc"]
  s.require_path = 'lib'
end