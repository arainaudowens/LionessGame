class GameWorld
  def initialize(window, animalType)
    @window = window

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
    @animals.map do |a|
      if a.collide?(@lioness)
        @window.GameState = :GameOver
      end
    end
  end

  def draw
    backgroundColor = 0xFF556611
    @window.draw_quad(0, 0, backgroundColor, 0, @window.height, backgroundColor, @window.width, 0, backgroundColor, @window.width, @window.height, backgroundColor, 0)
    @lioness.draw
    @animals.each do |a|
      a.draw
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      @window.GameState = :PauseMenu
    else
      @lioness.button_down(id)
    end
  end

  def generate_animals(animal)
    @lioness = Lioness.new(@window)

    @animals = []
    10.times do
      @animals << animal.new(@window)
    end
  end
end