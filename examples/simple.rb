$:.unshift(File.dirname(__FILE__))
require 'shared'

migration "Simple Migration Example", 1, Company do
  description "An simple example migration"

  up do
    puts "Simple Migration Example: Up"
    Messages << "Simple Migration Example: Up"
  end

  down do
    puts "Simple Migration Example: Down"
    Messages << "Simple Migration Example: Down"
  end		
end

migrate_up!
Messages.dump