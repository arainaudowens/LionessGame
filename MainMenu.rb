class MainMenu
  def initialize(window)
    @window = window
    @titleFont = Gosu::Font.new(@window, "Helvetica", 30)
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
    @menuItems = []
    @selectedItem = 0
    @selectedArrow = Gosu::Image.new(@window, "images/newarrow.png", false)

    yDrawPos = 2 * (@window.height / 8)
    yIncrement = @window.height / 8
    xDrawPos = 120
    menuTitles = ["Start Game", "Exit"]
    menuTitles.each do |title|
      @menuItems << [title, xDrawPos, yDrawPos]
      yDrawPos += yIncrement
    end
  end
  
  def update
  end

  def draw
    @titleFont.draw("Lioness Game", (@window.width/2) - @titleFont.text_width("Lioness Game")/2, @window.height/8, 0)
    @menuItems.each do |i|
      @font.draw(i[0], i[1], i[2], 1)
    end
    @selectedArrow.draw(@menuItems[@selectedItem][1] - ((@selectedArrow.width) * 0.1), @menuItems[@selectedItem][2]-7, 1, 0.1, 0.1)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close  # exit on press of escape key
    elsif id == Gosu::KbUp and @selectedItem != 0
      @selectedItem -= 1
    elsif id == Gosu::KbDown and @selectedItem < @menuItems.length-1
      @selectedItem += 1
    elsif id == Gosu::KbReturn or id == Gosu::KbEnter
      if @menuItems[@selectedItem][0] == "Exit"
        close
      elsif @menuItems[@selectedItem][0] == "Start Game"
        @window.GameState = :gameWorld
      end
    end
  end
end
