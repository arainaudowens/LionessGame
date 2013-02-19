class Wildebeest < Animal
  def initialize(window)
    super(window)

    @img = Gosu::Image.load_tiles(@window, "images/wildebeesttiles.png", -5, -1, false)
    @speed = 1.5

    @counter = 0
    @imgcounter = 0
    @still = false

    @turnSpeed = 2
  end

  def update
    super

    # Pick a direction
    @counter %= 60
    if @counter == 0
      if rand(0..3) == 0
        @still = true
      else
        @still = false
      end
      newdir = rand(0..359)
      @desiredDirection = newdir if not @still
    end
    @counter += 1

    @imgcounter %= 40
    @imgcounter += 1
    if @still
      @imgcounter = 0
    end

    move unless @still
  end

  def draw
    @img[(@imgcounter/10).floor].draw_rot(@x, @y, @zorder, @currentDirection)
  end
end