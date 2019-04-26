require 'rails_helper'

describe Game do

  let(:game) { Game.new }
  before do
    game.setup(width: 5, height: 10)
  end

  describe "snake movement" do
    let(:snake_id) { game.spawn_snake("mike", x: 2, y: 3) }

    context "when the snake has registered an intent" do

    end
  end
end