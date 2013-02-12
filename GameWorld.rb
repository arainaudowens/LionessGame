class GameWorld
  def initialize(window)
    @window = window
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
    @stringu = "gameworl"
  end
  
  def update

  end

  def draw
    @font.draw(@stringu, 0, 0, 1)
  end
end