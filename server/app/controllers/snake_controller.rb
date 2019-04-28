class SnakeController < ApplicationController
  def register_snake
    snake = Snake.new(params[:name])
    snake.save
  end

  def set_intent
  end
end