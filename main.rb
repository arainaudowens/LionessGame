require 'rubygems'
require 'gosu'

require_relative 'GameWorld.rb'
require_relative 'MainMenu.rb'

class GameWindow < Gosu::Window
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
      close  # exit on press of escape key
    end
    if id == Gosu::KbG
      @GameState = :gameWorld
    end
    if id == Gosu::KbM
      @GameState = :mainMenu
    end
  end
end

window = GameWindow.new
window.show
