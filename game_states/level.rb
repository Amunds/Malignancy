class Level < GameState
  traits :viewport, :timer
  def initialize()
    super
    $window.caption = "Test #{$window.fps}"
    self.viewport.game_area = [0, 0, 12000, 12000]
    self.viewport.lag = 0.95
    @file = File.join(ROOT, "levels", self.filename + ".oel")
    load_game_objects(:file => @file)
    
    @lift = Lift.create(:x => 1450, :y => 800, :zorder => 300, :from_y => 800, :to_y => 1000)
    
    @background = Image["background.png"]
    @player = Player.create( :x => 1300, :y => 600, :zorder => 300)
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
  end
  
  def update
    super
    self.viewport.x = @player.x - $window.width/2
    self.viewport.y = @player.y - ($window.height - 320)
    
    Bullet.each_bounding_box_collision(Platform) do |bullet, tile|
      bullet.die
    end
  end
  
  def load_game_objects(options = {})
    file = options[:file] || self.filename + ".oel"
    except = Array(options[:except]) || []
    
    require 'nokogiri'
    
    puts "* Loading game objects from #{file}"
    if File.exists?(file)
      objects = Nokogiri::XML(File.read(file))
      objects.xpath("//text()").remove
      objects.xpath("//level/*").each do |o|
        #p o.values.to_s.capitalize
        klass = Kernel::const_get(String.classify(o.values))
        #Kernel::const_get(o.values.to_s.capitalize)
        unless klass.class == "GameObject" && !except.include?(klass)
          o.children.each do |c|
            attributes = Hash[c.keys[2].to_sym => c.values[2].to_i, c.keys[3].to_sym => c.values[3].to_i]
            klass.create(attributes)
          end
        end
      end
    end
    self.game_objects.sync
  end
end