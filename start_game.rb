#!/opt/local/bin/ruby

require 'rubygems'
require 'pretty-fsm'
require 'chingu'
include Gosu
include Chingu

require_rel 'game_objects/'
require_rel 'game_states/'

class Game < Chingu::Window
  def initialize
    super(1024,768, false)
    self.input = {:esc => :exit}
    switch_game_state(Level.new)
  end
  
  def setup
    retrofy # This create non-smooth edges, fixes the black lines on tiles
  end
end

Game.new.show