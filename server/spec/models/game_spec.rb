require 'rails_helper'

describe Game do
  let(:game) { Game.new }

  before do
    game.setup(width: 10, height: 8)
  end

  let(:snake_id) { game.spawn_test_snake("mike", x: 2, y: 3) }
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

  describe "collisions" do
    context 'when there is no collision' do
      let!(:other_snake_id) { game.spawn_test_snake("other", x: 3, y: 3) }

      before do
        game.add_intent(snake_id, 'N')
        game.add_intent(other_snake_id, 'E')
      end

      it 'should do nothing' do
        game.tick

        expect(game.alive_snakes.length).to eq(2)
        expect(game.dead_snakes).to be_empty
      end
    end

    context "when running off the board or into an obstacle" do
      before do
        game.world[3][3].type = :wall
        game.add_intent(snake_id, 'E')
      end

      it 'should kill the snake' do
        game.tick

        expect(game.dead_snakes.length).to eq(1)
        expect(game.alive_snakes).to be_empty
      end
    end

    context "when colliding with another snake" do
      let!(:other_snake_id) { game.spawn_test_snake("other", x: 3, y: 3) }

      before do
        game.add_intent(snake_id, 'E')
        game.add_intent(other_snake_id, 'N')
      end

      it 'should kill the snake that is colliding' do
        game.tick

        expect(game.alive_snakes.map(&:id)).to eq([other_snake_id])
        expect(game.dead_snakes.length).to eq(1)
      end
    end

    context "when colliding with self" do
      before do
        snake.segment_positions = [game.world[3][1].to_h]
        snake.save
        game.add_intent(snake_id, 'W')
      end

      it 'should kill the snake' do
        game.tick

        expect(game.alive_snakes).to be_empty
        expect(game.dead_snakes.length).to eq(1)
      end
    end

    context "when a head on collision" do
      let!(:other_snake_id) { game.spawn_test_snake("other", x: 3, y: 3) }

      before do
        game.add_intent(snake_id, 'E')
        game.add_intent(other_snake_id, 'W')
      end

      it 'should kill both snakes' do
        game.tick

        expect(game.alive_snakes).to be_empty
        expect(game.dead_snakes.length).to eq(2)
      end
    end
  end
end