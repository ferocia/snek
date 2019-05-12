require_relative './util/path_finder.rb'

class HungrySnake
  def initialize(our_snake, game_state, map)
    @our_snake = our_snake
    @game_state = game_state
    @map = map

    @map_matrix = Array.new(height) { Array.new(width) { 1 } }

    @map.each_with_index do |row, y|
      row.each_with_index do |square, x|
        @map_matrix[y][x] = 0 if square == '#'
      end
    end

    @game_state['alive_snakes'].each do |snake|
      snake[:body].each do |bod|
        @map_matrix[bod['y']][bod['x']] = 0
      end
    end

    @food = @game_state['items'].detect {|i| i['itemType'] == 'food'}
  end

  def get_intent
    # This snek will not return an intent when the food cannot be pathed to.
    # You'll have to sort that out :D
    path_finder = PathFinder.new(@map_matrix)
    path_finder.next_step_to_shortest_path(current_x, current_y, food_x, food_y)
  end

  private
  def width
    @map.first.size
  end

  def height
    @map.size
  end

  def current_x
    @our_snake.fetch("head").fetch(:x)
  end

  def current_y
    @our_snake.fetch("head").fetch(:y)
  end

  def food_x
    @food['position']['x']
  end

  def food_y
    @food['position']['y']
  end
end
