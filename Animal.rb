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
    @direction = rand(0..359)
    @speed

    @img
    @zorder = 1
    @scaling = 1
  end

  def update

  end

  def draw
    @img.draw_rot(@x, @y, @zorder, @direction, 0.5, 0.5, @scaling, @scaling)
  end

  def button_down(id)

  end

  def move
    xChange = Math.cos(@direction.gosu_to_radians) * get_speed
    yChange = Math.sin(@direction.gosu_to_radians) * get_speed
    @x = xEdgeCheck(@x, xChange)
    @y = yEdgeCheck(@y, yChange)
  end

  def xEdgeCheck(x, xChange)
    newX = x + xChange
    xOffset = @img.width / 2

    leftX = newX - xOffset
    rightX = newX + xOffset
    newX = @window.WORLD_EDGE_LEFT if leftX <= @window.WORLD_EDGE_LEFT - xOffset
    newX = @window.WORLD_EDGE_RIGHT if rightX >= @window.WORLD_EDGE_RIGHT + xOffset

    newX
  end

  def yEdgeCheck(y, yChange)
    newY = y + yChange
    yOffset = @img.height / 2

    upY = newY - yOffset
    downY = newY + yOffset
    newY = @window.WORLD_EDGE_UP if upY <= @window.WORLD_EDGE_UP - yOffset
    newY = @window.WORLD_EDGE_DOWN if downY >= @window.WORLD_EDGE_DOWN + yOffset

    newY
  end

  def collide?(animal)
    return true if (@x - animal.x).abs < 30 and (@y - animal.y).abs < 30
    return false
  end

  def get_speed
    @speed
  end
end