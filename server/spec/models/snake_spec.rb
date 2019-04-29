require 'rails_helper'

describe Snake do
  describe "persistance" do
    it "should create a new snake as a member of new_snakes and only return the snake once" do
      snake = Snake.new("bob")
      snake.save

      expect(Snake.new_snakes).to eq([snake])
      expect(Snake.new_snakes).to be_empty
    end
  end
end