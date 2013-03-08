class Wildebeest < Animal
  def initialize(window, gameWorld)
    super(window, gameWorld)

    @img = Gosu::Image.load_tiles(@window, "images/wildebeesttiles.png", -5, -1, false)
    @speed = 1.5
    @turnSpeed = 2
    @FoV

    @still = false

    #Chipmunk physicsy stuff
    #poly = [Vec2.new(-17, -20), Vec2.new(-17, 14), Vec2.new(-13, 19), Vec2.new(13, 19), Vec2.new(17, 14), Vec2.new(17, -20), Vec2.new(13, -25), Vec2.new(-13, -25)]
    @shape = CP::Shape::Circle.new(@body, 30, CP::Vec2.new(0,0))
    @shape.collision_type = :prey
    @shape.object = self
    gameWorld.space.add_shape(@shape)
  end

  def draw
    @img[(Gosu::milliseconds / 500) % @img.length].draw_rot(@body.pos.x, @body.pos.y, @zorder, @currentDirection)
  end
end