require 'rails_helper'

describe Game do
  let(:game) { Game.new }

  before do
    game.setup(width: 5, height: 10)
  end

  let(:snake_id) { game.spawn_snake("mike", x: 2, y: 3) }
  let(:snake) { game.find_snake(snake_id) }

  describe "snake movement" do
    context "when the snake has registered an intent" do
      it 'should move the snake in that direction' do
        game.add_intent(snake_id, 'N')

        game.tick
        position = snake.head
        expect(position.x).to eq(2)
        expect(position.y).to eq(2)
      end
    end

    context 'when the snake has registered no intent' do
      it 'should still move the snake according to last intent given' do
        current_position = snake.head
        game.tick
        expect(snake.head).to_not eq(current_position)
      end
    end
  end

  describe "growth" do
    before do
      game.iteration = iteration
    end
    context 'when a iterations is not divisible by 5' do
      let(:iteration) { 26 }

      it 'should grow the snake' do
        expect(snake.length).to eq(1)
        game.tick
        expect(snake.length).to eq(1)
      end
    end

    context 'when a iterations is divisible by 5' do
      let(:iteration) { 25 }

      it 'should grow the snake' do
        expect(snake.length).to eq(1)
        game.tick
        expect(snake.length).to eq(2)
      end
    end
  end
end