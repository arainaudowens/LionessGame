class Wildebeest < Animal
  def initialize(window)
    super(window)

    @img = Gosu::Image.new(@window, "images/wildebeest.png", false)
    @speed = 0.6

    @counter = 0
    @still = false
  end

  def update
    # pick a direction
    @counter %= 60
    if @counter == 0
      if rand(0..3) == 0
        @still = true
      else
        @still = false
      end
      newdir = rand(0..359)
      @direction = newdir if not @still
    end
    @counter += 1

    move unless @still
  end

  def draw
    @img.draw_rot(@x, @y, @zorder, @direction)
  end

  def collide?(animal)
    return true if (@x - animal.x).abs < 25 and (@y - animal.y).abs < 25
    return false
  end
end