$:.unshift(File.dirname(__FILE__))
require 'shared'

migration "Complex Migration Example", 2, Company, Staff do
  description "An simple example migration"

  up do
    @messages ||= []
    Messages << "Complex Migration Example: Up"
  end

  down do
    @messages ||= []
    Messages << "Complex Migration Example: Down"
  end		
end

migrate_up!
Messages.dump