class Lift < GameObject
  traits :timer, :collision_detection, :velocity
  attr_accessor :box, :from_y, :to_y
  include PrettyFSM::Abbreviate
  
  def initialize(options = {})
    super
    @box = Rect.new([@x, @y, 64, 12])
    @from_y = options[:from_y]
    @to_y = options[:to_y]
    @image = Image['crate.png']
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
  
  def draw
    super
  end
  
  def update
    super
    p @from_y
    p @to_y
    p self.y
    @box.y = self.y
    if self.y >= @from_y.to_f
      self.velocity_y = -1
    elsif self.y == @to_y.to_f
      self.velocity_y = 1      
    end
  end
end