require "bundler"
Bundler.setup

gemspec = eval(File.read("snowflake-migration.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["snowflake-migration.gemspec"] do
  system "gem build snowflake-migration.gemspec"
  system "gem install snowflake-migration-#{Snowflake::Migration::VERSION}.gem"
end

Dir['tasks/**/*.rake'].each { |t| load t }