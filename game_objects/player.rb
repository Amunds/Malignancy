class Player < GameObject
  traits :velocity, :collision_detection

  attr_accessor :pressed_left, :pressed_right, :pressed_jump
  include PrettyFSM::Abbreviate
    
  def initialize(options = {})
    super
    @box = Rect.new([@x, @y, 48, 64])
    @direction = :right
    @accel = 0.2
    @skid = 0.4
    @decel = 0.9
    @image = Image["player.png"]
    @pressed_jump = false
    @pressed_left = false
    @pressed_right = false
    self.acceleration_y = 0.3
    self.max_velocity_y = 10
    self.max_velocity_x = 10
    @fsm = PrettyFSM::FSM.new(self, self.initial_state) do
      transition :from => :idle, :to => :moving, :if => :can_move?
      transition :from => :idle, :to => :jumping, :if => :can_jump?
      transition :from => :idle, :to => :falling, :if => :can_fall?
      
      transition :from => :moving, :to => :idle, :if => :stopped?
      transition :from => :moving, :to => :jumping, :if => :can_jump?
      transition :from => :moving, :to => :falling, :if => :can_fall?
            
      #transition :from => :jumping, :to => :moving, :if => Proc.new { !self.can_fall? and self.velocity_x != 0 }
      transition :from => :jumping, :to => :falling, :if => :can_fall?
      #transition :from => :jumping, :to => :idle, :if => :collide_platform?
      #transition :from => :jumping, :to => :moving, :if => :moving_and_collide_platform?
            
      transition :from => :falling, :to => :moving, :if => :moving_and_collide_platform?
      transition :from => :falling, :to => :idle, :if => :collide_platform?
    end
  end
    
  def bounding_box
    @box
  end
    
  def initial_state
    #puts "initial_state"
    if self.first_collision(Platform)
      @previous_state = :idle
    else
      @previous_state = :falling
    end
  end
    
  # idle state functions
  def start_idle
    puts "start_idle"
  end

  def while_idle
    puts "idling"
    self.resolve_collisions
  end

  def end_idle
  end

  def stopped?
    puts "stopped?"
    return true if self.velocity_x == 0 and ((not @pressed_left) and (not @pressed_right))
  end

  # walking/running state functions
  def start_moving
    puts "start_moving"
  end

  def while_moving
    puts "moving"
    # if user is pressing a direction button
    #self.resolve_collisions
    if @pressed_right && self.velocity_x < 0
      self.acceleration_x = 0
      #self.velocity_x += @skid
    elsif @pressed_left && self.velocity_x > 0
      self.acceleration_x = 0
      #self.velocity_x -= @skid
    elsif @pressed_right
      @direction = :right
      #self.velocity_x += @accel unless self.velocity_x >= @max_velocity
      self.acceleration_x = @accel
    elsif @pressed_left
      @direction = :left
      #self.velocity_x -= @accel unless self.velocity_x <= -@max_velocity
      self.acceleration_x = -@accel
    end
      
    #if user is not pressing a direction button
    if (not @pressed_right) and (not @pressed_left)
      # bring player to a stop if velocity is less than a whole number and
      # close to zero
      if @fsm.state == :jumping or @fsm.state == :falling
        self.acceleration_x = 0
      else
        if (self.velocity_x > 0 and self.velocity_x < 1) or (self.velocity_x < 0 and self.velocity_x > -1)
          self.velocity_x = 0
          self.acceleration_x = 0
        end

        if self.velocity_x > 0
          self.velocity_x -= @decel unless (self.velocity_x - @skid) < 0
          self.acceleration_x = -@decel
        elsif self.velocity_x < 0
          self.velocity_x += @decel unless (self.velocity_x + @skid) > 0 
          self.acceleration_x = @decel
        end
      end
    end
    self.resolve_collisions
  end
    
  def can_move?
    #puts "can_move?"
    @pressed_left or @pressed_right
  end

  # jumping functions
  def start_jumping
    #puts "start_jumping"
    @y -= 1
    self.velocity_y = -10
  end

  def while_jumping
    #puts "jumping"
    if @pressed_jump == false
      self.velocity_y += 1
    end
    self.while_moving
  end
   
  def can_jump?
    #puts "can_jump?"
    return true if @pressed_jump and ((@fsm.state != :falling) and (@fsm.state != :jumping))
    return false
  end
    
  # falling functions
  def start_falling
    #puts "start_falling"
  end
    
   def while_falling
      #puts "falling"
      self.while_moving
   end

   def end_falling
   end

   def can_fall?
      #puts "can_fall?"
      self.each_collision(Platform) do
         if @fsm.state == :jumping
            return true
         end
         return false
      end
      return false if self.velocity_y < 0
      return false if (@fsm.state == :jumping) and velocity == 0
      return true
   end
    
  def moving_and_collide_platform?
    if self.velocity_x == 0
      return false
    end
    return self.collide_platform?
  end

  def collide_platform?
    self.each_collision(Platform) do
      return true
    end
    return false
  end
   
   def update
      @fsm.advance
      # keep box from leaving sides of screen
      if @x < 0
        @x = 0
        self.velocity_x = 0
        self.acceleration_x = 0
      end
      @box.x = @x
      @box.y = @y
   end

  def draw
    if @direction == :right
      offs_x = 0
      factor = 1.0
    elsif @direction == :left
      offs_x = 28
      factor = -1.0
    end
    @image.draw(@x + offs_x, @y, 400, factor.to_f, 1)
  end
   
  def fire
    @bullet = Bullet.create(:x => self.x, :y => self.y + 24, :zorder => 600)
    if @direction == :right
      @bullet.velocity_x += 12
    else
      @bullet.velocity_x -= 12
    end
  end
   
   # Collision response
  def resolve_collisions
    self.each_collision(Platform) do | me, platform |
      me.resolve_platforms(platform)
    end
    
    self.each_collision(Lift) do |me, lift|
      me.resolve_platforms(lift)
      p "collision lift"
      #self.input = { :d => Proc.new { lift.activate } }
    end
  end

  def resolve_platforms(platform)
    if @box.bottom_side.collide_rect?(platform.box.top_side)# and self.velocity_y > 0
      @y = platform.box.y - @box.height
      p "colliding top"
    elsif @box.top_side.collide_rect?(platform.box.bottom_side) and self.velocity_y < 0 and self.velocity_y > 0 and @x + @box.width < platform.x + 5
      @y = platform.box.y + platform.box.height + 1
      self.velocity_y = 0
    elsif @box.left_side.collide_rect?(platform.box.right_side) and self.velocity_x < 0
      @x = platform.box.x + platform.box.width
      self.velocity_x = 0
      self.acceleration_x = 0
    elsif @box.right_side.collide_rect?(platform.box.left_side) and self.velocity_x > 0
      @x = platform.box.x - @box.width
      self.velocity_x = 0
      self.acceleration_x = 0
    end
  end
end