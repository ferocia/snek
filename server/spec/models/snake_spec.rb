require 'rails_helper'

describe Snake do
  describe "persistance" do
    it "should create a new snake as a member of new_snakes and only return the snake once" do
      snake = Snake.new(name: "bob", ip_address: '127.0.0.1')
      snake.save!

      expect(Snake.new_snakes).to eq([snake])
    end
  end

  describe "movement" do
    let!(:snake) { Snake.create(name: 'bob', ip_address: '123.34.56.7', items: [item]) }
    before do
      snake.set_position({x: 3, y: 3})
      snake.move({x: 4, y:5}, false)
    end

    context 'when the snake has items that have not expired' do
      let(:item) { {item_type: "food", turns_left: "3"} }

      it 'should decrement turns left' do
        expect(snake.items).to eq([{"item_type" => "food", "turns_left" => 2}])
        expect(snake).to have_food
      end
    end

    context 'when the snake has items that have expired' do
      let(:item) { {item_type: "food", turns_left: "1"} }

      it 'should delete the item' do
        expect(snake.items).to be_empty
        expect(snake).to_not have_food
      end
    end
  end
end