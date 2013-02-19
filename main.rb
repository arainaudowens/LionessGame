require 'rubygems'
require 'gosu'

require_relative 'GameWorld'
require_relative 'MainMenu'
require_relative 'PauseMenu'
require_relative 'GameOver'
require_relative 'Animal'
require_relative 'Lioness'
require_relative 'Wildebeest'
require_relative 'Zebra'
require_relative 'Gazelle'

class GameWindow < Gosu::Window
  attr_accessor :WORLD_EDGE_LEFT, :WORLD_EDGE_RIGHT, :WORLD_EDGE_UP, :WORLD_EDGE_DOWN
  attr_accessor :GameState

  def initialize
    super(Gosu.screen_width, Gosu.screen_height, true)
    #super(640, 480, false)
    self.caption = "Lioness Game"

    # initializing the constants for the edge of the world
    # they must go here for now instead of GameWorld
    # because Animals do not have access to GameWorld, just window
    @WORLD_EDGE_LEFT = -5
    @WORLD_EDGE_RIGHT = self.width + 5
    @WORLD_EDGE_UP = -5
    @WORLD_EDGE_DOWN = self.height + 5

    @MainMenu = MainMenu.new(self)
    @GameWorld
    @PauseMenu
    @GameOver
    @GameState = :MainMenu

    # GameState management done with a hash
    define_GSHash
  end

  def update
    @GSHash[@GameState].update
  end

  def draw
    @GSHash[@GameState].draw
  end

  def button_down(id)
    @GSHash[@GameState].button_down(id)
  end

  def new_game(animalType)
    @GameWorld = GameWorld.new(self, animalType)
    @PauseMenu = PauseMenu.new(self, @GameWorld)
    @GameOver = GameOver.new(self, @GameWorld, @MainMenu)
    define_GSHash
  end

  def define_GSHash
    @GSHash = {
      :MainMenu => @MainMenu,
      :GameWorld => @GameWorld,
      :PauseMenu => @PauseMenu,
      :GameOver => @GameOver
    }
  end
end

window = GameWindow.new
window.show