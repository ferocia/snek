class Game
  attr_accessor :world, :iteration, :snakes

  def setup(width: 100, height: 100)
    @iteration = 0
    @snakes = []
    @world = Array.new(width) {|x| Array.new(height) {|y| Tile.new(x: x, y: y) } }
  end

  def spawn_snake(name, x: nil, y: nil)
    position = if x && y
      @world[x][y]
    else
      # safe_spawn_point
    end
    @snakes.push(Snake.new(name: name, position: position))
  end



  def tick
    process_intents
    kill_colliding_snakes

    # Snakes grow!
    unless @iteration % 5 == 0
      trim_tail_off_snakes
    end
    @iteration += 1
  end

  private

  def safe_spawn_point
  end
end