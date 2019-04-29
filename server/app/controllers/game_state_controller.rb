class GameStateController < ApplicationController
  def register_snake
    snake = Snake.new(params[:name])
    snake.save

    render json: {snake_uuid: snake.uuid, auth_token: snake.auth_token}
  end

  def set_intent

  end

  def map
    map = $redis.get("map")
    if map
      render json: Marshal.load(map)
    else
      render json: {message: "No game in progress"}
    end
  end
end