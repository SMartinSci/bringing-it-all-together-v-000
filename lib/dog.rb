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

end
