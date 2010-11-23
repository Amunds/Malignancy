class Lift < GameObject
  traits :timer, :velocity, :collision_detection
  attr_accessor :box
  include PrettyFSM::Abbreviate
  
  def initialize(options = {})
    super
    @box = Rect.new([@x, @y, 64, 12])
    @color = Color.new(255,0,255,0)
    @fsm = PrettyFSM::FSM.new(self, self.initial_state) do
       transition :from => :idle, :to => :moving, :if => :can_move?
       transition :from => :moving, :to => :idle, :if => :stopped?
    end
  end
  
  def bounding_box
    @box
  end
  
  def initial_state
     puts "initial_state"
  end
  
  def draw
    $window.fill_rect(@box, @color)
  end
end