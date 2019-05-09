require 'rails_helper'

describe Snake do
  describe "persistance" do
    it "should create a new snake as a member of new_snakes and only return the snake once" do
      snake = Snake.new(name: "bob", ip_address: '127.0.0.1')
      snake.save!

      expect(Snake.new_snakes).to eq([snake])
    end
  end
end