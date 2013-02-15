class Animal
  def initialize(window)
    @window = window

    @x = rand(0..@window.width)
    @y = rand(0..@window.height)
    while ((@window.width / 2) - @x).abs <= 50
      @x = rand(0..@window.width)
    end
    while ((@window.height / 2) - @y).abs <= 50
      @y = rand(0..@window.height)
    end
    @zorder = 1
    @direction = rand(0..359)

    @img
    @speed
  end

  def update

  end

  def draw
    @img.draw_rot(@x, @y, @zorder, @direction)
  end

  def move
    xChange = Math.cos(@direction.gosu_to_radians) * @speed
    yChange = Math.sin(@direction.gosu_to_radians) * @speed
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

  def button_down(id)

  end
end