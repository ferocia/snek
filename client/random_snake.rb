class RandomSnake
  def initialize(our_snake, game_state, map)
    @game_state = game_state
    @map = map
    @our_snake = our_snake
    @current_position = @our_snake.fetch("head")
  end

  def get_intent
    # Let's evaluate a random move
    possible_moves = ["N", "S", "E", "W"].shuffle
    # chosen_move = possible_moves.detect{|move|
    #   !collides_with_wall?(current_position, move, map) &&
    #   !collides_with_body?(current_position, our_snake.fetch("body"))
    # }
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