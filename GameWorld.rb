class GameWorld
  attr_accessor :WORLD_EDGE_LEFT, :WORLD_EDGE_RIGHT, :WORLD_EDGE_UP, :WORLD_EDGE_DOWN, :lioness, :space

  def initialize(window, animalType)
    @window = window

    # Initializing the constants for the edge of the world
    @WORLD_EDGE_LEFT = -5
    @WORLD_EDGE_RIGHT = @window.width + 5
    @WORLD_EDGE_UP = -5
    @WORLD_EDGE_DOWN = @window.height + 5

    #Chipmunk stuff
    @space = CP::Space.new

    @AnimalHash = {
      "Wildebeest" => Wildebeest,
      "Zebra" => Zebra,
      "Gazelle" => Gazelle
    }

    generate_animals(@AnimalHash[animalType])
  end

  def update
    @lioness.update
    @animals.each do |a|
      a.update
    end
    @space.step(1)
  end

  def draw
    backgroundColor = 0xFF556611
    @window.draw_quad(0, 0, backgroundColor, 0, @window.height, backgroundColor, @window.width, 0, backgroundColor, @window.width, @window.height, backgroundColor, 0)
    @lioness.draw
    @animals.each do |a|
      a.draw
    end

    @window.flush

    # Draw the energy bar's background grey.
    @window.draw_quad(@window.width - 2, 0, Gosu::Color::GRAY,
                      @window.width, 0, Gosu::Color::GRAY,
                      @window.width - 2, @window.height, Gosu::Color::GRAY,
                      @window.width, @window.height, Gosu::Color::GRAY)

    # Draw the energy bar's foreground cyan.
    @window.draw_quad(@window.width - 2, @window.height, Gosu::Color::CYAN,
                      @window.width, @window.height, Gosu::Color::CYAN,
                      @window.width - 2, @window.height - @window.height * (@lioness.energy / Lioness::MAX_ENERGY), Gosu::Color::CYAN,
                      @window.width, @window.height - @window.height * (@lioness.energy / Lioness::MAX_ENERGY), Gosu::Color::CYAN)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      @window.GameState = :PauseMenu
    else
      @lioness.button_down(id)
    end
  end

  def generate_animals(animal)
    @lioness = Lioness.new(@window, self)

    @animals = []
    10.times do
      @animals << animal.new(@window, self)
    end
  end
end