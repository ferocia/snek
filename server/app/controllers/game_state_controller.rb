class GameStateController < ApplicationController
  def register_snake
    if !Snake.find_by(ip_address: request.remote_ip, died_at: nil)
      snake = Snake.new(name: params[:name], ip_address: request.remote_ip)
      snake.save

      render json: {snake_id: snake.id, auth_token: snake.auth_token}
    else
      render json: {message: "Sorry - a snake is already registered for your IP"}
    end
  end

  def set_intent
    snake = Snake.find_by!(id: params[:id], auth_token: params[:auth_token])

    if snake
      snake.update_attributes!(intent: params[:intent])
      render json: {status: "ok"}
    end
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