class Wildebeest < Animal
  def initialize(window)
    super(window)

    @img = Gosu::Image.load_tiles(@window, "images/wildebeesttiles.png", -5, -1, false)
    @speed = 1.5
    @turnSpeed = 2

    @imgcounter = 0
    @still = false
  end

  def update
    super

    @imgcounter += 1
    @imgcounter %= 40
    if still?
      @imgcounter = 0
    end
  end

  def draw
    @img[(@imgcounter/10).floor].draw_rot(@x, @y, @zorder, @currentDirection)
  end
end