class Platform < GameObject
  has_traits :collision_detection
  attr_accessor :color, :radius, :box
    
  def initialize(options = {})
    super
    @box = Rect.new([@x, @y, 128,128])
    #@color = options[:color] or Color.new(255,255,0,0)
    @color2 = Color.new(255,0,128,255)
  end
    
  def setup
    @image ||= Image["#{self.filename}.png"]
    #@image = Image["crate.png"]
  end
    
  def bounding_box
    @box
  end
    
  def draw
    @image.draw(@x,@y,200)
  end
end

class Concrete < Platform
end

class Crate < Platform
  def initialize(options = {})
    super
    @box = Rect.new([@x, @y, 64,64])
  end
end