require 'securerandom'

class Snake
  attr_accessor :name, :uuid, :head, :intent, :last_intent

  def initialize(name:, initial_position:)
    @name = name
    @head = initial_position
    @uuid = SecureRandom.uuid
    @segments = []
    @last_intent = ['N', 'S', 'E', 'W'].sample
  end

  def move(new_tile, should_grow)
    @segments.unshift @head
    @segments.pop unless should_grow
    @head = new_tile
    @last_intent = @intent
    @intent = nil
  end

  def length
    @segments.count + 1
  end

  def ==(other)
    @uuid == other.uuid
  end

  def collides_with?(other)
    tiles_to_check_for_collisions = if self == other
      @segments
    else
      other.occupied_space
    end
  end

  def occupied_space
    [@head] + @segments
  end
end