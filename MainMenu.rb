class MainMenu
  INITIAL_X_DRAW = 120
  INITIAL_Y_DRAW = 200
  INITIAL_Y_INCREMENT = 100

  def initialize(window)
    @window = window

    @titleFont = Gosu::Font.new(@window, "Helvetica", 30)
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
    @menuItems = []
    @selectedItem = 0
    @selectedArrow = Gosu::Image.new(@window, "images/arrow.png", false)

    @rootTitles = ["Start Game", "Exit"]
    @preyTitles = ["Wildebeest", "Zebra", "Gazelle", "Back"]

    root
  end

  def update

  end

  def draw
    @titleFont.draw("Lioness Game", (@window.width/2) - @titleFont.text_width("Lioness Game")/2, @window.height/8, 0)
    @menuItems.each do |i|
      @font.draw(i[0], i[1], i[2], 1)
    end
    @selectedArrow.draw(@menuItems[@selectedItem][1] - ((@selectedArrow.width) * 0.1), @menuItems[@selectedItem][2] - 5, 1, 0.1, 0.1)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      @window.close
    elsif id == Gosu::KbUp and @selectedItem != 0
      @selectedItem -= 1
    elsif id == Gosu::KbDown and @selectedItem < @menuItems.length-1
      @selectedItem += 1
    elsif id == Gosu::KbReturn or id == Gosu::KbEnter
      selectedTitle = @menuItems[@selectedItem][0]
      if selectedTitle == "Start Game"
        create_draw_list(@preyTitles, INITIAL_X_DRAW, INITIAL_Y_DRAW, INITIAL_Y_INCREMENT)
        @selectedItem = 0
      elsif selectedTitle == "Wildebeest" or selectedTitle == "Zebra" or selectedTitle == "Gazelle"
        @window.new_game(selectedTitle)
        @window.GameState = :GameWorld
      elsif selectedTitle == "Back"
        root
      elsif selectedTitle == "Exit"
        @window.close
      end
    end
  end

  def root
    create_draw_list(@rootTitles, INITIAL_X_DRAW, INITIAL_Y_DRAW, INITIAL_Y_INCREMENT)
    @selectedItem = 0
  end

  # Draws a new menu by clearing and repopulating the @menuItems array
  def create_draw_list(titleList, xDrawPos, yDrawPos, yIncrement)
    @menuItems = []
    titleList.each do |title|
      @menuItems << [title, xDrawPos, yDrawPos]
      yDrawPos += yIncrement
    end
  end
end
