require 'rubygems'
require 'gosu'
require 'chipmunk'

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
  attr_accessor :GameState

  def initialize(fullscreen = false)
    super(Gosu.screen_width, Gosu.screen_height, true) if fullscreen
    super(640, 480, false) if !fullscreen
    self.caption = "Lioness Game"

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

  def needs_cursor?
    @GameState == :GameWorld
  end
end

puts "a for fullscreen, nothing otherwise"
fs = gets.chomp == "a"
window = GameWindow.new fs
window.show