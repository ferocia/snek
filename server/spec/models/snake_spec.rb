require 'rails_helper'

describe Snake do
  describe "persistance" do
    it "should create a new snake as a member of new_snakes" do
      snake = Snake.new("bob")
      snake.save

      expect(Snake.new_snakes).to eq([snake])
    end
  end
end