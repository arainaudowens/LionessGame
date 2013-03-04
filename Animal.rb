class Animal
  attr_reader :x, :y

  def initialize(window, gameWorld)
    @window = window
    @GameWorld = gameWorld

    @x = rand(0..@window.width)
    @y = rand(0..@window.height)
    while @x < 200 and @y < 200
      @x = rand(0..@window.width)
      @y = rand(0..@window.height)
    end

    @currentDirection = rand(0..359)
    @desiredDirection = @currentDirection
    @turnSpeed = 5
    @speed = 5

    @img = Gosu::Image.load_tiles(@window, "images/wildebeesttiles.png", -5, -1, false)[0]
    @zorder = 1
    @scaling = 1
  end

  def update
    update_move_state
    unless still?
      turn
      move
    end
  end

  def draw
    @img.draw_rot(@x, @y, @zorder, @currentDirection, 0.5, 0.5, @scaling, @scaling)
  end

  def button_down(id)

  end

  def turn
    get_new_direction
    update_direction
  end

  def get_new_direction
    @desiredDirection = -Math.atan2((@y - @GameWorld.lioness.y), (@GameWorld.lioness.x - @x)).radians_to_gosu % 360
  end

  def update_direction
    # A positive turn direction is turning right, a negative is turning left
    ddiff = @currentDirection - @desiredDirection
    if ddiff >= 180 or (ddiff < 0 and ddiff >= -180)
      turnDirection = 1
    elsif ddiff <= -180 or (ddiff > 0 and ddiff <= 180)
      turnDirection = -1
    else
      turnDirection = 0
    end

    # Turn towards the desired direction
    if one_turn_frame_away(@currentDirection + (@turnSpeed * turnDirection))
      @currentDirection = @desiredDirection
    else
      @currentDirection += @turnSpeed * turnDirection
      @currentDirection %= 360
    end
  end

  def one_turn_frame_away(nextdir)
    case nextdir
    when -Float::INFINITY...0 # looped around left
      if @currentDirection > @desiredDirection or @desiredDirection > nextdir % 360
        true
      else
        false
      end
    when 360..Float::INFINITY # looped around right
      if @currentDirection < @desiredDirection or @desiredDirection < nextdir % 360
        true
      else
        false
      end
    else
      if @desiredDirection.between?(@currentDirection, nextdir) or @desiredDirection.between?(nextdir, @currentDirection)
        true
      else
        false
      end
    end
  end

  def update_move_state
    @still = false
    @still = true unless Gosu::distance(@x, @y, @GameWorld.lioness.x, @GameWorld.lioness.y).between?(0, 250)
  end

  def move
    xChange = Math.cos(@currentDirection.gosu_to_radians) * self.speed
    yChange = Math.sin(@currentDirection.gosu_to_radians) * self.speed
    @x = xEdgeCheck(@x, xChange)
    @y = yEdgeCheck(@y, yChange)
  end

  def xEdgeCheck(x, xChange)
    newX = x + xChange
    xOffset = @img[0].width / 2

    leftX = newX - xOffset
    rightX = newX + xOffset
    newX = @GameWorld.WORLD_EDGE_LEFT if leftX <= @GameWorld.WORLD_EDGE_LEFT - xOffset
    newX = @GameWorld.WORLD_EDGE_RIGHT if rightX >= @GameWorld.WORLD_EDGE_RIGHT + xOffset

    newX
  end

  def yEdgeCheck(y, yChange)
    newY = y + yChange
    yOffset = @img[0].height / 2

    upY = newY - yOffset
    downY = newY + yOffset
    newY = @GameWorld.WORLD_EDGE_UP if upY <= @GameWorld.WORLD_EDGE_UP - yOffset
    newY = @GameWorld.WORLD_EDGE_DOWN if downY >= @GameWorld.WORLD_EDGE_DOWN + yOffset

    newY
  end

  def collide?(animal)
    return true if (@x - animal.x).abs < 20 and (@y - animal.y).abs < 20
    return false
  end

  def speed
    @speed
  end

  def still?
    @still
  end
end