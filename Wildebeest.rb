class Wildebeest < Animal
  def initialize(window, gameWorld)
    super(window, gameWorld)

    @img = Gosu::Image.load_tiles(@window, "images/wildebeesttiles.png", -5, -1, false)
    @speed = 1.5
    @turnSpeed = Math::PI / 90
    @FoV

    @still = false

    # Chipmunk physicsy stuff
    bodyPoly = [CP::Vec2.new(-7, -40), CP::Vec2.new(-11, -13), CP::Vec2.new(-11, 17), CP::Vec2.new(-4, 30), CP::Vec2.new(3, 30), CP::Vec2.new(10, 17), CP::Vec2.new(10, -13), CP::Vec2.new(6, -40)]
    bodyShape = CP::Shape::Poly.new(@body, bodyPoly, CP::Vec2::ZERO)
    bodyShape.collision_type = :prey
    bodyShape.object = self
    gameWorld.space.add_shape(bodyShape)
  end

  def draw
    if @dead
      @img.last.draw_rot(@body.pos.x, @body.pos.y, @zorder, @body.a.radians_to_gosu)
    else
      @img[(Gosu::milliseconds / 500) % 4].draw_rot(@body.pos.x, @body.pos.y, @zorder, @body.a.radians_to_gosu)
    end
  end

  def die
    @dead = true
  end
end