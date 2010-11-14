class Bullet < GameObject
  has_traits :timer, :collision_detection, :velocity
  trait :bounding_box, :debug => false
  
  def setup
    @image = Image["bullet.png"]
  end
  
  def die
    destroy
  end
end