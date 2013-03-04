class Wildebeest < Animal
  def initialize(window, gameWorld)
    super(window, gameWorld)

    @img = Gosu::Image.load_tiles(@window, "images/wildebeesttiles.png", -5, -1, false)
    @speed = 1.5
    @turnSpeed = 2
    @FoV

    @still = false
  end

  def draw
    @img[(Gosu::milliseconds / 500) % @img.length].draw_rot(@x, @y, @zorder, @currentDirection)
  end
end