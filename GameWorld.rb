class GameWorld
  def initialize(window)
    @window = window

    #@font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
    @lioness = Lioness.new(@window)
    @animals = []
    1..10.times do
      @animals << Wildebeest.new(@window)
    end
  end

  def update
    @lioness.update
    @animals.each do |a|
      a.update
    end
  end

  def draw
    backgroundColor = 0xFF556611
    @window.draw_quad(0, 0, backgroundColor, 0, @window.height, backgroundColor, @window.width, 0, backgroundColor, @window.width, @window.height, backgroundColor, 0)
    @lioness.draw
    @animals.each do |a|
      a.draw
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      @window.GameState = :mainMenu
    else
      @lioness.button_down(id)
    end
  end
end