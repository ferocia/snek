class Game
  attr_accessor :world, :iteration, :snakes, :dead_snakes

  def setup(width: 100, height: 100)
    @iteration = 0
    @snakes = []
    @dead_snakes = []
    @width = width
    @height = height
    @world = Array.new(width) {|x| Array.new(height) {|y| Tile.new(x: x, y: y) } }
  end

  def spawn_snake(name, x: nil, y: nil)
    position = if x && y
      @world[x][y]
    else
      # safe_spawn_point
    end
    snake = Snake.new(name: name, initial_position: position)
    @snakes.push(snake)
    snake.uuid
  end

  def add_intent(snake_id, direction)
    snake = find_snake(snake_id)

    if snake
      snake.intent = direction
    end
  end

  def tick
    # Snakes grow every 5 ticks
    process_intents(should_grow: @iteration % 5 == 0)

    kill_colliding_snakes

    @iteration += 1
  end

  def find_snake(snake_id)
    @snakes.detect{|s| s.uuid == snake_id }
  end

  private

  def process_intents(should_grow:)
    @snakes.each do |snake|
      current_position = snake.head
      new_x, new_y = case snake.intent || snake.last_intent
      when 'N' then [current_position.x, current_position.y - 1]
      when 'S' then [current_position.x, current_position.y + 1]
      when 'E' then [current_position.x + 1, current_position.y]
      when 'W' then [current_position.x - 1, current_position.y]
      else [0, 0] # Dead on invalid move
      end

      snake.move(@world[new_x][new_y], should_grow)
    end
  end

  def kill_colliding_snakes
    dying_snakes = @snakes.select do |snake|
      @snakes.detect{|s| snake.collides_with?(s) }
    end
  end

  def safe_spawn_point
  end
end