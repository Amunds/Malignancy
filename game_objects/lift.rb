class Lift < GameObject
  traits :timer, :collision_detection, :velocity
  attr_accessor :box, :from_y, :to_y
  include PrettyFSM::Abbreviate
  
  def initialize(options = {})
    super
    @box = Rect.new([@x, @y, 64, 64])
    @from_y = options[:from_y].to_f
    @to_y = options[:to_y].to_f
    @image = Image['crate.png']
    self.velocity_y = 0
    @fsm = PrettyFSM::FSM.new(self, self.initial_state) do
       transition :from => :idle, :to => :moving, :if => :can_move?
       transition :from => :moving, :to => :idle, :if => :stopped?
    end
  end
  
  def bounding_box
    @box
  end
  
  def initial_state
  end
  
  def activate
    if self.y == @from_y 
      if @from_y > @to_y
        self.velocity_y = -1
      elsif @from_y < @to_y
        self.velocity_y = 1
      end
    elsif self.y == @to_y
      if @from_y > @to_y
        self.velocity_y = 1
      elsif @from_y < @to_y
        self.velocity_y = -1
      end
    end
  end
  
  def move_down
    self.velocity_y = 1
    p "move up"
  end
  
  def move_up
    self.velocity_y = -1
    p "move down"
  end
  
  def stand_still
    self.velocity_y = 0
    p "standing"
  end
  
  def draw
    super
  end
  
  def update
    super
    p @from_y
    p @to_y
    p self.y
    @box.y = self.y - 32 #TODO: FIx collision on this CLass
    
    if self.y == @from_y or self.y == @to_y 
      self.stand_still
    end
  end
end