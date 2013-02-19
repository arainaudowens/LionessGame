class Lioness < Animal
  def initialize(window)
    super(window)
    @x = 50
    @y = 50
    @zorder = 2
    @currentDirection = 135
    @desiredDirection = @currentDirection

    #@img = Gosu::Image.new(@window, "images/lionessresized.png", false)
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

    @pounceCounter = 0
    @turnSpeed = 5
  end

  def update
    super
    pounce_update
    @imgcounter %= 40
    @imgcounter += 1

    unless @SpeedState == :pouncing or @SpeedState == :recovering
      shift = @window.button_down?(Gosu::KbLeftShift) or @window.button_down?(Gosu::KbRightShift)
      alt = @window.button_down?(Gosu::KbLeftAlt) or @window.button_down?(Gosu::KbRightAlt)
      if shift and not alt
        @SpeedState = :sprint
      elsif alt
        @SpeedState = :prowl
      else
        @SpeedState = :normal
      end
    end

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
      @desiredDirection = 315
    elsif right and up
      @desiredDirection = 45
    elsif left and down
      @desiredDirection = 225
    elsif right and down
      @desiredDirection = 135
    elsif left
      @desiredDirection = 270
    elsif right
      @desiredDirection = 90
    elsif up
      @desiredDirection = 0
    elsif down
      @desiredDirection = 180
    elsif @pounceCounter <= 0
      @SpeedState = :still
    end
    move
  end

  def draw
    if @SpeedState == :pouncing
      @img[4].draw_rot(@x, @y, @zorder, @currentDirection, 0.5, 0.5, @scaling, @scaling)
    elsif @SpeedState == :still
      @img[0].draw_rot(@x, @y, @zorder, @currentDirection)
    else
      @img[(@imgcounter/10).floor].draw_rot(@x, @y, @zorder, @currentDirection)
    end
  end

  def button_down(id)
    if id == Gosu::KbSpace and @pounceCounter == 0
      @SpeedState = :pouncing
      @zorder = 3
      @scaling = 1.2
      @pounceCounter = 1
    end
  end

  def get_speed
    @SpeedHash[@SpeedState]
  end

  def pounce_update
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
end