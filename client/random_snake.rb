class RandomSnake
  def initialize(our_snake, game_state, map)
    # Game state is an hash with the following structure
    # {
    #   alive_snakes: [{snake}],
    #   leaderboard: []
    # }
    # Each snake is made up of the following:
    # {
    #   id: id,
    #   name: name,
    #   head: {x: <int>, y: <int>,
    #   color: <string>,
    #   length: <int>,
    #   body: [{x: <int>, y: <int>}, etc.]
    # }
    @game_state = game_state
    # Map is a 2D array of chars.  # represents a wall and '.' is a blank tile.
    # The map is fetched once - it does not include snake positions - that's in game state.
    # The map uses [y][x] for coords so @map[0][0] would represent the top left most tile
    @map = map
    @our_snake = our_snake
    @current_position = @our_snake.fetch("head")
  end

  def get_intent
    # Let's evaluate a random move
    possible_moves = ["N", "S", "E", "W"].shuffle

    # Note we should probably avoid walls, or our tail or other snakes hey...
    # An exercise for the reader!

    if @current_position.fetch("x") < 10
      "N"
    elsif @current_position.fetch("x") > 90
      "S"
    elsif @current_position.fetch("y") > 90
      "W"
    elsif @current_position.fetch("y") < 10
      "E"
    else
      possible_moves.first
    end
  end
end