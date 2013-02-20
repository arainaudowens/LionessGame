class Zebra < Animal
  def initialize(window)
    super(window)

    @img = Gosu::Image.load_tiles(@window, "images/zebratiles.png", -4, -1, false)
    @speed = 2.5
    @turnSpeed = 3

    @imgcounter = 0
    @still = false
  end

  def update
    super

    @imgcounter += 1
    @imgcounter %= 80
    if still?
      @imgcounter = 0
    end
  end

  def draw
    @img[(@imgcounter/20).floor].draw_rot(@x, @y, @zorder, @currentDirection)
  end
end