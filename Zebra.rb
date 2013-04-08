class Zebra < Animal
  def initialize(window, gameWorld)
    super(window, gameWorld)

    @img = Gosu::Image.load_tiles(@window, "images/zebratiles.png", -4, -1, false)
    @speed = 2.5
    @turnSpeed = 3

    @still = false

    # Chipmunk physicsy stuff
    bodyPoly = [CP::Vec2.new(-7, -40), CP::Vec2.new(-11, -13), CP::Vec2.new(-11, 17), CP::Vec2.new(-4, 30), CP::Vec2.new(3, 30), CP::Vec2.new(10, 17), CP::Vec2.new(10, -13), CP::Vec2.new(6, -40)]
    bodyShape = CP::Shape::Poly.new(@body, bodyPoly, CP::Vec2::ZERO)
    bodyShape.collision_type = :prey
    bodyShape.object = self
    gameWorld.space.add_shape(bodyShape)
  end

  def draw
    @img[(Gosu::milliseconds / 500) % @img.length].draw_rot(@body.pos.x, @body.pos.y, @zorder, @currentDirection)
  end

  def die
    @dead = true
  end
end