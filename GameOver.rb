class GameOver
  def initialize(window, gameWorld, mainMenu)
    @window = window
    @GameWorld = gameWorld
    @MainMenu = mainMenu
    @gameOverFont = Gosu::Font.new(@window, Gosu::default_font_name, 40)
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
  end

  def update

  end

  def draw
    # Draw the current state of the GameWorld to be used as a backdrop
    @GameWorld.draw

    # Draw a semi-transparent black box over the game world
    modalColor = 0x88000000
    @window.draw_quad(0, 0, modalColor, 0, @window.height, modalColor, @window.width, 0, modalColor, @window.width, @window.height, modalColor, 10)

    # Draw the text
    gameOverText = "YOU WIN"
    subtext = "Press enter to return to the main menu."
    @gameOverFont.draw(gameOverText, @window.width / 2 - (@gameOverFont.text_width(gameOverText) / 2), @window.height / 3, 11)
    @font.draw(subtext, @window.width / 2 - (@font.text_width(subtext) / 2), @window.height / 3 + 40, 11)
  end

  def button_down(id)
    if id == Gosu::KbEnter or id == Gosu::KbReturn or id == Gosu::KbEscape
      @window.GameState = :MainMenu
      @MainMenu.root
    end
  end
end