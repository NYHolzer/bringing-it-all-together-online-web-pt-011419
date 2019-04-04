class Dog 

  attr_accessor :name, :breed 
  attr_reader :id 

  def initialize (id: nil, name:, breed:)
    @id = id 
    @name = name 
    @breed = breed
  end 
  
  def self.create_table 
    self.drop_table
    
    sql = <<-SQL 
    CREATE TABLE dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL
    
    DB[:conn].execute(sql)
  end 

  def self.drop_table 
    DB[:conn].execute("DROP TABLE IF EXISTS dogs")
  end 
  
  def save 
    sql = <<-SQL
      INSERT INTO dogs (name, breed) VALUES (?, ?)
    SQL
    
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
    
    self
  end 

end 