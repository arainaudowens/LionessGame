class Lioness < Animal
  attr_reader :MAX_ENERGY, :energy

  MAX_ENERGY = 200
  SPRINT_REGEN = 0.5

  def initialize(window, gameWorld)
    super(window, gameWorld)

    @zorder = 2
    @currentDirection = 135
    @desiredDirection = @currentDirection

    @img = Gosu::Image.load_tiles(@window, "images/lionesstiles.png", -5, -1, false)
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

    #Chipmunk physicsy stuff
    @body = CP::Body.new(1.0, CP::INFINITY)  # mass, moi
    @body.pos = CP::Vec2.new(50, 50)
    @body.object = self
    #poly = [Vec2.new(-17, -20), Vec2.new(-17, 14), Vec2.new(-13, 19), Vec2.new(13, 19), Vec2.new(17, 14), Vec2.new(17, -20), Vec2.new(13, -25), Vec2.new(-13, -25)]
    @shape = CP::Shape::Circle.new(@body, 30, CP::Vec2.new(0,0))
    @shape.collision_type = :lioness
    @shape.object = self
    gameWorld.space.add_shape(@shape)
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
    if @SpeedState == :pouncing
      @img[4].draw_rot(@body.pos.x, @body.pos.y, @zorder, @currentDirection, 0.5, 0.5, @scaling, @scaling)
    elsif @SpeedState == :still
      @img[0].draw_rot(@body.pos.x, @body.pos.y, @zorder, @currentDirection)
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
      @energy += SPRINT_REGEN * 2
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
        @energy += SPRINT_REGEN
      else
        @SpeedState = :normal
        @energy += SPRINT_REGEN
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
      puts "ow"
    end
  end
end