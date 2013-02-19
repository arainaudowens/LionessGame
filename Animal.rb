class Animal
  attr_reader :x, :y

  def initialize(window)
    @window = window

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
    update_direction
  end

  def draw
    @img.draw_rot(@x, @y, @zorder, @currentDirection, 0.5, 0.5, @scaling, @scaling)
  end

  def button_down(id)

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
      case @desiredDirection
      when @currentDirection..nextdir, nextdir..@currentDirection
        true
      else
        false
      end
    end
  end

  def move
    xChange = Math.cos(@currentDirection.gosu_to_radians) * get_speed
    yChange = Math.sin(@currentDirection.gosu_to_radians) * get_speed
    @x = xEdgeCheck(@x, xChange)
    @y = yEdgeCheck(@y, yChange)
  end

  def xEdgeCheck(x, xChange)
    newX = x + xChange
    xOffset = @img[0].width / 2

    leftX = newX - xOffset
    rightX = newX + xOffset
    newX = @window.WORLD_EDGE_LEFT if leftX <= @window.WORLD_EDGE_LEFT - xOffset
    newX = @window.WORLD_EDGE_RIGHT if rightX >= @window.WORLD_EDGE_RIGHT + xOffset

    newX
  end

  def yEdgeCheck(y, yChange)
    newY = y + yChange
    yOffset = @img[0].height / 2

    upY = newY - yOffset
    downY = newY + yOffset
    newY = @window.WORLD_EDGE_UP if upY <= @window.WORLD_EDGE_UP - yOffset
    newY = @window.WORLD_EDGE_DOWN if downY >= @window.WORLD_EDGE_DOWN + yOffset

    newY
  end

  def collide?(animal)
    return true if (@x - animal.x).abs < 20 and (@y - animal.y).abs < 20
    return false
  end

  def get_speed
    @speed
  end
end