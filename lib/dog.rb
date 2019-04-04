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
  
  def self.create (attributes)
    new_dog = self.new(name: attributes[:name], breed: attributes[:breed])
    new_dog.save
    new_dog
  end 
  
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end 
  
  def self.find_by_id (x)
    sql = <<-SQL
      SELECT * FROM dogs WHERE id = ?
    SQL
    
    array = DB[:conn].execute(sql, x)
  end 

end 