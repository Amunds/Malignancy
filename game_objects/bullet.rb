class Bullet < GameObject
  has_traits :timer, :collision_detection, :velocity
  
  def setup
    @image = Image["bullet.png"]
  end
  
  def die
    self.destroy
  end
  
  def update
    if self.outside_window?
      self.die
    end
  end
end