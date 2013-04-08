class Lioness < Animal
  attr_reader :window, :MAX_ENERGY, :energy

  MAX_ENERGY = 200.0
  ENERGY_REGEN = 0.5

  def initialize(window, gameWorld)
    super(window, gameWorld)

    @zorder = 2
    @currentDirection = 135
    @desiredDirection = 135

    @img = Gosu::Image.load_tiles(@window, "images/lionesstiles.png", -6, -1, false)
    @imgcounter = 0

    @SpeedState = :normal
    @SpeedHash = {
      :still => 0,
      :prowl => 1,
      :recovering => 1.5,
      :normal => 3,
      :sprint => 5,
      :pouncing => 10
    }

    # Initialize the lioness in Chipmunk space
    @body = CP::Body.new(1.0, CP::INFINITY) # mass, moi
    @body.pos = CP::Vec2.new(50, 50)
    @body.object = self
    gameWorld.space.add_body(@body)

    # Only the front part of the lioness can kill.
    huntingPoly = [CP::Vec2.new(9, -19), CP::Vec2.new(9, -36), CP::Vec2.new(4, -41), CP::Vec2.new(-4, -41), CP::Vec2.new(-9, -36), CP::Vec2.new(-9, -19)]
    huntingShape = CP::Shape::Poly.new(@body, huntingPoly, CP::Vec2::ZERO)
    huntingShape.collision_type = :lioness
    huntingShape.object = self

    # The back part should just be treated as a solid body (working as :prey currently)
    bodyPoly = [CP::Vec2.new(-9, 22), CP::Vec2.new(-2, 31), CP::Vec2.new(2, 31), CP::Vec2.new(9, 22), CP::Vec2.new(9, -19), CP::Vec2.new(-9, -19)]
    bodyShape = CP::Shape::Poly.new(@body, bodyPoly, CP::Vec2::ZERO)
    bodyShape.collision_type = :prey
    bodyShape.object = self

    # Add these shapes to the Chipmunk space
    gameWorld.space.add_shape(huntingShape)
    gameWorld.space.add_shape(bodyShape)
    gameWorld.space.add_collision_handler(:lioness, :prey, Prey_Collisions.new)

    @pounceCounter = 0
    @turnSpeed = 5

    @energy = MAX_ENERGY
  end

  def update
    @imgcounter %= 40
    @imgcounter += 1

    super
  end

  def draw
    if @window.GameState == :GameOver
      @img.last.draw_rot(@body.pos.x, @body.pos.y, @zorder, @currentDirection)
    elsif @SpeedState == :still
      @img[0].draw_rot(@body.pos.x, @body.pos.y, @zorder, @currentDirection)
    elsif @SpeedState == :pouncing
      @img[4].draw_rot(@body.pos.x, @body.pos.y, @zorder, @currentDirection, 0.5, 0.5, @scaling, @scaling)
    else
      @img[(@imgcounter/10).floor].draw_rot(@body.pos.x, @body.pos.y, @zorder, @currentDirection)
    end
  end

  def button_down(id)
    if (id == Gosu::KbSpace or id == Gosu::MsRight) and @pounceCounter == 0 and @energy >= 20
      @SpeedState = :pouncing
      @zorder = 3
      @scaling = 1.2
      @pounceCounter = 1
      @energy -= 20
    end
  end

  def get_new_direction
    @desiredDirection = -Math.atan2((@window.mouse_y - @body.pos.y), (@body.pos.x - @window.mouse_x)).radians_to_gosu % 360
  end

  def update_move_state
    update_pounce

    # Hold left click to move, don't move if you're already where you want to go, and you can't be still while pouncing
    if (!@window.button_down?(Gosu::MsLeft) or (@body.pos.x == @window.mouse_x and @body.pos.y == @window.mouse_y)) and @SpeedState != :pouncing
      @SpeedState = :still
      @energy += ENERGY_REGEN * 2
    elsif !(@SpeedState == :pouncing or @SpeedState == :recovering)
      shift = @window.button_down?(Gosu::KbLeftShift) or @window.button_down?(Gosu::KbRightShift)
      alt = @window.button_down?(Gosu::KbLeftAlt) or @window.button_down?(Gosu::KbRightAlt)
      if shift and not alt
        @SpeedState = :sprint
        @energy -= 1
        if @energy <= 0
          @energy = 0
          @SpeedState = :normal
        end
      elsif alt
        @SpeedState = :prowl
        @energy += ENERGY_REGEN
      else
        @SpeedState = :normal
        @energy += ENERGY_REGEN
      end
    end

    if @energy > MAX_ENERGY
      @energy = MAX_ENERGY
    end
  end

  def move
    if one_move_frame_away
      @body.pos.x = @window.mouse_x
      @body.pos.y = @window.mouse_y
    else
      super
    end
  end

  def one_move_frame_away
    xChange = Math.cos(@currentDirection.gosu_to_radians) * self.speed
    yChange = Math.sin(@currentDirection.gosu_to_radians) * self.speed
    (@window.mouse_x.between?(@body.pos.x - xChange, @body.pos.x + xChange) or       # You must check both ways
      @window.mouse_x.between?(@body.pos.x + xChange, @body.pos.x - xChange)) and    # because xChange and yChange can
    (@window.mouse_y.between?(@body.pos.y - yChange, @body.pos.y + yChange) or       # be either positive or negative
      @window.mouse_y.between?(@body.pos.y + yChange, @body.pos.y - yChange))        # and between? is order sensitive
  end

  def update_pounce
    # Pounces last 10 frames with 30 frame cooldown
    if @pounceCounter == 10
      @pounceCounter = -30
      @zorder = 2
      @scaling = 1
    end

    # The lioness moves slower when recovering from a pounce
    @SpeedState = :recovering if @pounceCounter < 0
    @SpeedState = :normal if @pounceCounter == 0

    # Update the pounce counter if necessary
    @pounceCounter += 1 if @SpeedState == :pouncing or @SpeedState == :recovering
  end

  def speed
    @SpeedHash[@SpeedState]
  end

  def still?
    @SpeedState == :still
  end

  def x
    @body.pos.x
  end

  def y
    @body.pos.y
  end

  class Prey_Collisions
    def begin (lioness_s, prey_s, contact)
      prey_s.object.die
      lioness_s.object.window.GameState = :GameOver
    end
  end
end