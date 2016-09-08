module Databaseable
  module ClassMethods
    def public_attributes
      self::ATTRIBUTES.keys.reject {|key| key == :id }
    end

    def attributes
      self::ATTRIBUTES
    end

    def db
      DB[:conn]
    end

    def table_name
      "#{self.to_s.downcase}s"
    end

    def create_table
      column_attributes = self.attributes.map do |attribute_name, attribute_characteristic|
        "#{attribute_name.to_s} #{attribute_characteristic}" 
      end.join(", ")
      
      sql = <<-SQL
        CREATE TABLE IF NOT EXISTS #{self.table_name} (
          #{column_attributes}
        )
      SQL
      db.execute(sql)
    end

    def drop_table
      sql = <<-SQL
        DROP TABLE #{self.table_name}
      SQL

      db.execute(sql)
    end

    def find(id)
    sql = <<-SQL
      SELECT * FROM #{self.table_name} WHERE id = ?;
    SQL

    row = self.db.execute(sql, id)

    self.object_from_row(row.first)
  end

    def all
      sql = <<-SQL
        SELECT * FROM #{self.table_name};
      SQL

      rows = db.execute(sql)
      rows.map do |row|
        self.object_from_row(row)
      end
    end

    def objects_from_rows(rows)
      rows.map do |row|
        self.object_from_row(row)
      end
    end    

    def object_from_row(row)
      public_values = row[1..-1]
      zipped = self.public_attributes.zip(public_values)
      hash = Hash[zipped]
      
      object = self.new(hash)

      object.instance_variable_set("@id", row[0])
      object
    end    
  end
  module InstanceMethods
    def initialize(attributes = {})
      self.class.public_attributes.each do |attribute|  
        self.send("#{attribute}=", attributes[attribute])  
      end
    end

  def save
    if persisted?
      update
    else
      insert
    end
    self
  end

  def ==(other_object)
    self.id == other_object.id
  end


  def destroy
    sql_statement = <<-SQL
      DELETE from #{self.class.table_name} WHERE id = ?;
    SQL
    self.class.db.execute(sql_statement, self.id)
  end

  def persisted?
    !!self.id
  end

  # [:title, :page_count, :genre, :price]
  def public_values
    self.class.public_attributes.map do |attribute|
      self.send("#{attribute}")
    end
  end

  private 

  # ATTRIBUTES = {
  #   id: "INTEGER PRIMARY KEY",
  #   title: "TEXT",
  #   page_count: "INTEGER",
  #   genre: "TEXT",
  #   price: "INTEGER"
  # }

    def insert
      sql_string = self.class.public_attributes.map {|key| key.to_s }.join(", ")
      question_marks = self.class.public_attributes.map {|key| "?" }.join(", ")
      sql = <<-SQL
        INSERT INTO #{self.class.table_name} (#{sql_string}) VALUES
          (#{question_marks})
      SQL
      self.class.db.execute(sql, *self.public_values)
      select_last_row = <<-SQL
        SELECT id FROM #{self.class.table_name} ORDER BY id DESC LIMIT 1
      SQL
      id = self.class.db.execute(select_last_row).flatten.first
      @id = id

    end

    def update
      sql_string = self.class.public_attributes.map do |attribute|
        "#{attribute} = ?"
      end.join(", ")
      # [:title, :page_count, :genre]
      # ["title = ?", "page_count = ?"].join(", ")
      # title = ?, page_count = ?, genre = ?, price = ?
      sql_statement = <<-SQL
          UPDATE #{self.class.table_name} SET #{sql_string} WHERE id = ?;
      SQL
      self.class.db.execute(sql_statement, *self.public_values, self.id)
    end
  end
end