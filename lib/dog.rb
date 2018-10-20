require_relative "../config/environment.rb"

class Dog
  attr_accessor :name, :breed, :id

def initialize(id: nil, name:, breed:)
  @id = id
  @name = name
  @breed = breed
end

def self.find_or_create_by(name:, breed:)
    song = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !song.empty?
      dog_data = song[0]
      dog = Dog.new(dog_data[0], dog_data[1], dog_data[2])
    else
      dog = self.create(name: name, breed: breed)
    end
    dog
  end

  def self.new_from_db(row)
      id = row[0]
      name =  row[1]
      grade = row[2]
      self.new(id, name, breed)
  end

  def self.find_by_name(name)
      sql = "SELECT * FROM dogs WHERE name = ?"
      result = DB[:conn].execute(sql, name)[0]
      Dog.new(result[0], result[1], result[2])
    end

  def update
    sql = "UPDATE dogs SET name = ?, album = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end


  def save
    if self.id 
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed) 
        VALUES (?, ?)
      SQL
 
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
  end
end
