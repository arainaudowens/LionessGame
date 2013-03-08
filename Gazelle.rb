class Gazelle < Animal
  def initialize(window, gameWorld)
    super(window, gameWorld)

    @img = Gosu::Image.load_tiles(@window, "images/gazelletiles.png", -6, -1, false)
    @speed = 5.5
    @turnSpeed = 5

    @still = false
  end

  def draw
    @img[(Gosu::milliseconds / 500) % @img.length].draw_rot(@body.pos.x, @body.pos.y, @zorder, @currentDirection)
  end
end