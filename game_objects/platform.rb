class Platform < GameObject
  has_traits :collision_detection
  attr_accessor :color, :radius, :box
    
  def initialize(options = {})
    super
    @box = Rect.new([@x, @y, 128,128])
  end
    
  def setup
    @image ||= Image["#{self.filename}.png"]
  end
    
  def bounding_box
    @box
  end
    
  def draw
    @image.draw(@x,@y,200)
    #@image.retrofy
  end
end

class Concrete < Platform
  
end

class ConcreteWindow < Platform
  
end

class ConcreteFiller < Platform
  
end

class ConcreteTopleft < Platform
  
end

class Crate < Platform
  def initialize(options = {})
    super
    @box = Rect.new([@x, @y, 64,64])
  end
end