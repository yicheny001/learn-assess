class Owner
  include Databaseable::InstanceMethods
  extend Databaseable::ClassMethods
  ATTRIBUTES = {
    id: "INTEGER PRIMARY KEY",
    name: "TEXT",
  }

  attr_accessor(*self.public_attributes)  
  attr_reader :id

  def restaurants
  end
end