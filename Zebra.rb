class Zebra < Animal
  def initialize(window, gameWorld)
    super(window, gameWorld)

    @img = Gosu::Image.load_tiles(@window, "images/zebratiles.png", -4, -1, false)
    @speed = 2.5
    @turnSpeed = 3

    @still = false
  end

  def draw
    @img[(Gosu::milliseconds / 500) % @img.length].draw_rot(@x, @y, @zorder, @currentDirection)
  end
end