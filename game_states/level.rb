class Level < GameState
  traits :viewport
  def initialize()
    super
    $window.caption = "Test #{$window.fps}"
    self.viewport.game_area = [0, 0, 12000, 12000]
    self.viewport.lag = 0.95
    
    @platform = Platform::Concrete.create( :x => 0, :y => $window.height - 128)
    @platform2 = Platform::Concrete.create( :x => 128, :y => $window.height - 128)
    @platform3 = Platform::Concrete.create( :x => 256, :y => $window.height - 128)
    @platform4 = Platform::Concrete.create( :x => 384, :y => $window.height - 128)
    @platform5 = Platform::Concrete.create( :x => 512, :y => $window.height - 128)
    @platform6 = Platform::Concrete.create( :x => 640, :y => $window.height - 128)
    @platform7 = Platform::Concrete.create( :x => 768, :y => $window.height - 128)
    @platform8 = Platform::Concrete.create( :x => 896, :y => $window.height - 128)

    @platform11 = Platform::Crate.create( :x => 512, :y => $window.height - 192)
    @platform12 = Platform::Crate.create( :x => 640, :y => $window.height - 192)
    @platform13 = Platform::Crate.create( :x => 768, :y => $window.height - 192)
    @platform14 = Platform::Crate.create( :x => 640, :y => $window.height - 256)
    @background = Image["background.png"]
    @player = Player.create( :x => 100, :y => 200, :zorder => 300)
    @player.input = { :holding_left   => Proc.new { @player.pressed_left = true; @player.pressed_right = false },
                      :holding_right  => Proc.new { @player.pressed_right = true; @player.pressed_left = false },
                      :released_left  => Proc.new { @player.pressed_left = false },
                      :released_right => Proc.new { @player.pressed_right = false },
                      :holding_space  => Proc.new { @player.pressed_jump = true },
                      :released_space => Proc.new { @player.pressed_jump = false },
                      :left_shift => :fire
                    }
  end
  
  def draw
    super
      @background.draw(0,0,100)
  end
  
  def update
    super
    self.viewport.x = @player.x - $window.width/2
    self.viewport.y = @player.y - ($window.height - 180)
  end
end