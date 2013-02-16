class PauseMenu
  MENU_BORDER_PADDING = 40

  def initialize(window, gameWorld)
    @window = window
    @GameWorld = gameWorld

    # Menu Drawing
    yIncrement = @window.height / 8
    yDrawPos = 2 * (yIncrement)
    xCenter = @window.width / 2

    @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
    menuTitles = ["Resume Game", "Main Menu", "Exit"]
    @menuItems = [] # 2D array to contain menu titles and their X and Y draw positions

    # Background Drawing
    @menuBackground = [] # x1, x2, y1, y2 used for building the background for the pause menu
    @menuBackground[2] = yDrawPos + yIncrement - MENU_BORDER_PADDING # y1 = starting vertical draw height, padded and adjusted for the first increment

    # Menu Navigation
    @selectedItem = 0
    @selectedArrow = Gosu::Image.new(@window, "images/newarrow.png", false)

    # create the 2D array of menu titles and their draw positions
    menuTitles.each do |title|
      xOffset = (@font.text_width(title) / 2)
      yDrawPos += yIncrement

      @menuItems << [title, xCenter - xOffset, yDrawPos]

      # set a new x1, x2 if this is the widest menu item so far
      @menuBackground[0] = [@menuBackground[0], xCenter - xOffset - MENU_BORDER_PADDING].compact.min
      @menuBackground[1] = [@menuBackground[1], xCenter + xOffset + MENU_BORDER_PADDING].compact.max
    end

    @menuBackground[3] = yDrawPos + MENU_BORDER_PADDING # y2 = ending vertical draw height, padded
  end

  def update

  end

  def draw
    # Draw the current state of the GameWorld to be used as a backdrop
    @GameWorld.draw

    # Draw a semi-transparent black box over the game world
    modalColor = 0x88000000
    @window.draw_quad(0, 0, modalColor, 0, @window.height, modalColor, @window.width, 0, modalColor, @window.width, @window.height, modalColor, 10)

    # Draw the pause menu background box
    backgroundColor = 0xFFFFFFFF # white outer box
    backgroundColor2 = 0xFF000000 # black inner box
    @window.draw_quad(@menuBackground[0] - 5, @menuBackground[2] - 5, backgroundColor,
                      @menuBackground[1] + 5, @menuBackground[2] - 5, backgroundColor,
                      @menuBackground[0] - 5, @menuBackground[3] + 5, backgroundColor,
                      @menuBackground[1] + 5, @menuBackground[3] + 5, backgroundColor, 11)
    @window.draw_quad(@menuBackground[0], @menuBackground[2], backgroundColor2,
                      @menuBackground[1], @menuBackground[2], backgroundColor2,
                      @menuBackground[0], @menuBackground[3], backgroundColor2,
                      @menuBackground[1], @menuBackground[3], backgroundColor2, 12)

    # Draw the menu items
    @menuItems.each do |i|
      @font.draw(i[0], i[1], i[2], 13)
    end

    # Draw the selection arrows
    @selectedArrow.draw(@menuItems[@selectedItem][1] - ((@selectedArrow.width) * 0.1), @menuItems[@selectedItem][2] - 5, 13, 0.1, 0.1)
    @selectedArrow.draw_rot(@menuItems[@selectedItem][1] + @font.text_width(@menuItems[@selectedItem][0]) + ((@selectedArrow.width) * 0.1), @menuItems[@selectedItem][2] - 5, 13, 180, 0, 1, 0.1, 0.1)
  end

  def button_down(id)
    if id == Gosu::KbUp and @selectedItem != 0
      @selectedItem -= 1
    elsif id == Gosu::KbDown and @selectedItem < @menuItems.length-1
      @selectedItem += 1
    elsif id == Gosu::KbReturn or id == Gosu::KbEnter
      if @menuItems[@selectedItem][0] == "Resume Game"
        @window.GameState = :GameWorld
      elsif @menuItems[@selectedItem][0] == "Main Menu"
        @window.GameState = :MainMenu
      elsif @menuItems[@selectedItem][0] == "Exit"
        @window.close
      end
    end
  end
end