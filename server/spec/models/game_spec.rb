require 'rails_helper'

describe Game do
  def create_test_snake(name, x: , y: )
    snake = Snake.create(name: name, ip_address: '127.0.0.1')
    snake.set_position({x: x, y: y})

    snake
  end


  let!(:game) { Game.new }

  let(:width) { 10 }
  let(:height) { 8 }

  before do
    game.setup(width: width, height: height)
  end

  let(:snake) { create_test_snake("mike", x: 2, y: 3) }

  describe "spawning a snake" do
    let!(:snake) { Snake.create(name: "foo", ip_address: '127.0.0.1') }

    let!(:other_snake) { create_test_snake("other", x: 3, y: 1) }

    let(:width) { 6}
    let(:height) { 3}

    before do
      other_snake.update_attributes(segment_positions: [{x: 4, y: 1}] )
      other_snake.set_intent("W")
    end

    it 'should spawn in a free space' do
      game.tick
      snake.reload
      expect(snake.head.x).to eq(1)
      expect(snake.head.y).to eq(1)
    end
  end

  describe "spawning an item" do
    let!(:other_snake) { create_test_snake("other", x: 3, y: 1) }

    let(:width) { 6}
    let(:height) { 3}

    before do
      other_snake.update_attributes(segment_positions: [{x: 4, y: 1}] )
      other_snake.set_intent("W")
    end

    it 'should spawn in a free space' do
      game.tick
      expect(Item.first.position).to eq({"x" => 1, "y" => 1})
    end
  end

  describe "snake movement" do
    context "when the snake has registered an intent" do
      it 'should move the snake in that direction' do
        snake.set_intent('N')

        game.tick
        snake.reload
        position = snake.head
        expect(position.x).to eq(2)
        expect(position.y).to eq(2)
      end
    end

    context 'when the snake has registered no intent' do
      it 'should still move the snake according to last intent given' do
        current_position = snake.head
        game.tick
        snake.reload
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
        snake.reload
        expect(snake.length).to eq(2)
      end
    end
  end

  describe "collecting an item" do
    let!(:item) { Item.create(item_type: "food", position: {x: 3, y: 3}) }
    before do
      snake.set_intent('E')
    end

    it 'should pick up the item' do
      game.tick
      snake.reload

      expect(snake.items).to eq([{"item_type" => "food", "turns_left" => 5}])

      expect(Item.all).to be_empty
    end

    it 'should record an event' do
      game.tick
      snake.reload

      expect(game.events.count).to eq 1
    end
  end

  describe "collisions" do
    context 'when there is no collision' do
      let!(:other_snake) { create_test_snake("other", x: 3, y: 3) }

      before do
        snake.set_intent('N')
        other_snake.set_intent('E')
      end

      it 'should do nothing' do
        game.tick

        expect(Snake.alive.length).to eq(2)
        expect(Snake.dead).to be_empty
      end
    end

    context "when running off the board or into an obstacle" do
      before do
        game.world[3][3].type = :wall
        snake.set_intent('E')
      end

      it 'should kill the snake' do
        game.tick

        expect(Snake.dead.length).to eq(1)
        expect(Snake.alive).to be_empty
      end
    end

    context "when colliding with another snake" do
      let!(:other_snake) { create_test_snake("other", x: 3, y: 3) }

      before do
        snake.set_intent('E')
        other_snake.set_intent('N')
      end

      it 'should kill the snake that is colliding' do
        game.tick

        expect(Snake.alive.map(&:id)).to eq([other_snake.id])
        expect(Snake.dead.length).to eq(1)
        expect(game.events.count).to eq 1
      end
    end

    context "when colliding with self" do
      before do
        snake.segment_positions = [game.world[3][1].to_h]
        snake.save
        snake.set_intent('W')
      end

      it 'should kill the snake' do
        game.tick

        expect(Snake.alive).to be_empty
        expect(Snake.dead.length).to eq(1)
      end
    end

    context "when a head on collision" do
      let!(:other_snake) { create_test_snake("other", x: 3, y: 3) }

      before do
        snake.set_intent('E')
        other_snake.set_intent('W')
      end

      it 'should kill both snakes' do
        game.tick

        expect(Snake.alive).to be_empty
        expect(Snake.dead.length).to eq(2)
      end
    end
  end
end
