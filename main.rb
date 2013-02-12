require 'rubygems'
require 'gosu'

require_relative 'GameWorld.rb'
require_relative 'MainMenu.rb'

class GameWindow < Gosu::Window
  attr_accessor :GameState

  def initialize
    #super(Gosu.screen_width, Gosu.screen_height, true) 
    super(640,480,false)
    self.caption = "Lioness Game"

    # we load the font once during initialize, much faster than
    # loading the font before every draw
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    @MainMenu = MainMenu.new(self)
    @GameWorld = GameWorld.new(self)
    @GameState = :mainMenu
  end

  def update
    if(@GameState == :mainMenu)
      @MainMenu.update()
    elsif(@GameState == :gameWorld)
      @GameWorld.update()
    end
  end
  
  def draw
    if(@GameState == :mainMenu)
      @MainMenu.draw()
    elsif(@GameState == :gameWorld)
      @GameWorld.draw()
    end
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      if @GameState == :gameWorld
        @GameState = :mainMenu
      else
        close
      end
    elsif @GameState == :mainMenu
      @MainMenu.button_down(id)
    elsif @GameState == :gameWorld
      @GameWorld.button_down(id)
    end
  end
end

window = GameWindow.new
window.show
