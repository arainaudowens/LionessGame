class MainMenu
  def initialize(window)
    @window = window

    @INITIAL_X_DRAW = 120
    @INITIAL_Y_DRAW = 2 * @window.height / 8
    @INITIAL_Y_INCREMENT = @window.height / 8

    @titleFont = Gosu::Font.new(@window, "Helvetica", 30)
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
    @menuItems = []
    @selectedItem = 0
    @selectedArrow = Gosu::Image.new(@window, "images/arrow.png", false)

    @rootTitles = ["Start Game", "Settings", nil, "Exit"]
    @preyTitles = ["Wildebeest", "Zebra", "Gazelle", nil, "Back"]
    @settingsTitles = [nil, nil, "Back"]

    root
  end

  def update

  end

  def draw
    @titleFont.draw_rel("Lioness Game", (@window.width/2), @window.height/8, 0, 0.5, 0)
    @menuItems.each do |i|
      @font.draw(i[0], i[1], i[2], 1)
    end
    @selectedArrow.draw(@menuItems[@selectedItem][1] - ((@selectedArrow.width) * 0.1), @menuItems[@selectedItem][2] - 5, 1, 0.1, 0.1)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      
      @window.close

    elsif id == Gosu::KbUp and @selectedItem != @menuItems.index { |x| !x[0].nil? }
      loop do
        @selectedItem -= 1
        break if !@menuItems[@selectedItem][0].nil? or @selectedItem <= @menuItems.index { |x| !x[0].nil? }
      end

    elsif id == Gosu::KbDown and @selectedItem < @menuItems.length - 1
      loop do
        @selectedItem += 1
        break if !@menuItems[@selectedItem][0].nil? or @selectedItem == @menuItems.length - 1
      end

    elsif id == Gosu::KbReturn or id == Gosu::KbEnter
      selectedTitle = @menuItems[@selectedItem][0]

      # Main Menu
      if selectedTitle == "Start Game"
        create_draw_list(@preyTitles, @INITIAL_X_DRAW, @INITIAL_Y_DRAW, @INITIAL_Y_INCREMENT)
        @selectedItem = @menuItems.index { |x| !x[0].nil? }
      elsif selectedTitle == "Settings"
        create_draw_list(@settingsTitles, @INITIAL_X_DRAW, @INITIAL_Y_DRAW, @INITIAL_Y_INCREMENT)
        @selectedItem = @menuItems.index { |x| !x[0].nil? }
      elsif selectedTitle == "Exit"
        @window.close

      # Prey Selection Menu
      elsif selectedTitle == "Wildebeest" or selectedTitle == "Zebra" or selectedTitle == "Gazelle"
        @window.new_game(selectedTitle)
        @window.GameState = :GameWorld
      elsif selectedTitle == "Back"
        root

      # Settings Menu
      end
    end
  end

  def root
    create_draw_list(@rootTitles, @INITIAL_X_DRAW, @INITIAL_Y_DRAW, @INITIAL_Y_INCREMENT)
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
