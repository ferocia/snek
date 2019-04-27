class Game
  include ActiveModel::Serialization
  attr_accessor :world, :iteration, :snakes, :dead_snakes

  def setup(width: 100, height: 100)
    @iteration = 0
    @snakes = []
    @dead_snakes = []
    @width = width
    @height = height
    @world = Array.new(height) {|y| Array.new(width) {|x|
      type = if x == 0 || y == 0 || x == width - 1 || y == height - 1
        :wall
      end
      Tile.new(x: x, y: y, type: type)
    } }
  end

  def spawn_snake(name, x: nil, y: nil)
    position = if x && y
      @world[y][x]
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

  def to_s
    chars = @world.map{|row| row.map{|tile| tile.to_s }}
    @snakes.each do |snake|
      chars[snake.head.y][snake.head.x] = snake.intent || "@"
      snake.segments.each do |segment|
        chars[segment.y][segment.x] = "~"
      end
    end

    chars.map{|row| row.join }.join("\n")
  end

  def as_json(options = nil)
    {
      map: @world,
      snakes: @snakes
    }
  end

  private

  def process_intents(should_grow:)
    @snakes.each do |snake|
      current_position = snake.head
      new_y, new_x = case snake.intent || snake.last_intent
      when 'N' then [current_position.y - 1, current_position.x]
      when 'S' then [current_position.y + 1, current_position.x]
      when 'E' then [current_position.y, current_position.x + 1]
      when 'W' then [current_position.y, current_position.x - 1]
      else [0, 0] # Dead on invalid move
      end

      snake.move(@world[new_y][new_x], should_grow)
    end
  end

  def kill_colliding_snakes
    dying_snakes = @snakes.select do |snake|
      snake.head.wall? || @snakes.detect{|s| snake.collides_with?(s) }
    end
    @dead_snakes += dying_snakes
    @snakes = @snakes - dying_snakes
  end

  def safe_spawn_point
  end
end