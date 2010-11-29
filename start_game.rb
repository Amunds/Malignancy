#!/opt/local/bin/ruby

require 'rubygems'
require 'bundler/setup'
require 'pretty-fsm'
require 'chingu'
include Gosu
include Chingu


require_rel 'game_objects/'
require_rel 'game_states/'
require './lib/extensions'

class Game < Chingu::Window
  def initialize
    super(1024,768, false)
    self.input = {:esc => :exit}
    switch_game_state(Level.new)
  end
  
  def setup
    # TODO: Retrofy should be used only on the Platform class
    retrofy
  end
end

Game.new.show
