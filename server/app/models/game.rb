class Game
  include ActiveModel::Serialization
  attr_accessor :world, :iteration, :all_snakes, :dead_snakes, :alive_snakes

  def setup(width: 100, height: 100)
    @iteration = 0
    @all_snakes = []
    @alive_snakes = []
    @dead_snakes = []
    @width = width
    @height = height
    @world = Array.new(height) {|y| Array.new(width) {|x|
      type = if x == 0 || y == 0 || x == width - 1 || y == height - 1
        :wall
      end
      Tile.new(x: x, y: y, type: type)
    } }

    @safe_tiles = @world.flatten.reject(&:wall?)
  end

  def spawn_test_snake(name, x: , y: )
    snake = Snake.new(name)
    snake.set_position(@world[y][x])

    @all_snakes.push(snake)
    @alive_snakes.push(snake)
    snake.uuid
  end

  def add_intent(snake_id, direction)
    snake = find_snake(snake_id)

    if snake
      snake.intent = direction
    end
  end

  def spawn_new_snakes
    new_snakes = Snake.new_snakes

    possible_spawn_points = @safe_tiles - @alive_snakes.map(&:occupied_space).flatten

    new_snakes.each do |snake|
      spawn_point = possible_spawn_points.sample
      snake.set_position(spawn_point)
      @alive_snakes.push(snake)
      possible_spawn_points = possible_spawn_points.without(spawn_point)
    end
  end

  def tick
    # Snakes grow every 5 ticks
    process_intents(should_grow: @iteration % 5 == 0)

    kill_colliding_snakes

    spawn_new_snakes

    @iteration += 1
  end

  def find_snake(snake_id)
    @all_snakes.detect{|s| s.uuid == snake_id }
  end

  def to_s
    chars = @world.map{|row| row.map{|tile| tile.to_s }}
    @alive_snakes.each do |snake|
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
      snakes: @all_snakes
    }
  end

  private

  def process_intents(should_grow:)
    @all_snakes.each do |snake|
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
    # We need this to calculate collisions efficiently
    unsafe_tiles_this_tick = @alive_snakes.map(&:occupied_space).flatten

    dying_snakes = @alive_snakes.select do |snake|
      snake.head.wall? ||
      # We expect the head to be in the list - if it's there a second time though,
      # that's a collision with either self of another snake
      unsafe_tiles_this_tick.count(snake.head) > 1
    end

    @dead_snakes += dying_snakes
    @alive_snakes = @alive_snakes - dying_snakes
  end
end