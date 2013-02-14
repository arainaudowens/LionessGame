class Lioness < Animal
  def initialize(window)
    super(window)
    @x = @window.width / 2
    @y = @window.height / 2
    @zorder = 2
    @direction = 0

    @img = Gosu::Image.new(@window, "images/lionessresized.png", false)
    @speed = 3

=begin
    @scaling = 1
    @pouncing = false
    @pounceCounter = 0
=end
  end

  def update
=begin
    if @pouncing
      @pounceCounter += 1
      if @pounceCounter == 30
        @pouncing = false
        @pounceCounter = 0
        @zorder = 2
        @scaling = 1
      end
    end
=end

    left = @window.button_down?(Gosu::KbLeft)
    right = @window.button_down?(Gosu::KbRight)
    up = @window.button_down?(Gosu::KbUp)
    down = @window.button_down?(Gosu::KbDown)
    if left and right
      left = false
      right = false
    end
    if up and down
      up = false
      down = false
    end
    if left and up
      @direction = 315
      @speed = 3
    elsif right and up
      @direction = 45
      @speed = 3
    elsif left and down
      @direction = 225
      @speed = 3
    elsif right and down
      @direction = 135
      @speed = 3
    elsif left
      @direction = 270
      @speed = 3
    elsif right
      @direction = 90
      @speed = 3
    elsif up
      @direction = 0
      @speed = 3
    elsif down
      @direction = 180
      @speed = 3
    else
      @speed = 0
    end
    move
  end

  def draw
    @img.draw_rot(@x, @y, @zorder, @direction)
  end

  def button_down(id)
    if id == Gosu::KbLeftShift or id == Gosu::KbRightShift
=begin
      @pouncing = true
      @zorder = 3
      @scaling = 1.2
=end
    end
  end
end