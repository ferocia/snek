require 'securerandom'

class Snake
  include ActiveModel::Serialization

  attr_accessor :name, :uuid, :head, :intent, :last_intent, :segments

  def initialize(name)
    @name = name
    @uuid = SecureRandom.uuid
    @segments = []
    @last_intent = ['N', 'S', 'E', 'W'].sample
  end

  def set_position(initial_position)
    @head = initial_position
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

  def occupied_space
    [@head] + @segments
  end

  def self.new_snakes
    members = $redis.smembers("new_snakes")

    if members.any?
      $redis.mget(members).compact.map{|data|
        Marshal.load(data)
      }
    else
      []
    end
  end

  # Should probably just use AR at this point hey...
  def save
    $redis.set("snake_#{@uuid}", Marshal.dump(self))
    $redis.sadd("new_snakes", "snake_#{@uuid}")
  end
end