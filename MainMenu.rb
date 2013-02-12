class MainMenu
  def initialize(window)
    @window = window
    @titleFont
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
    @menuItems = []

    yDrawPos = @window.height / 6
    yIncrement = @window.height / 8
    xDrawPos = 80
    menuTitles = ["Lioness Game", "Start Game", "Settings", "Exit"]
    menuTitles.each do |title|
      @menuItems << [title, xDrawPos, yDrawPos]
      yDrawPos += yIncrement
    end
  end
  
  def update

  end

  def draw
    @menuItems.each do |i|
      @font.draw(i[0], i[1], i[2], 1)
    end
  end
end