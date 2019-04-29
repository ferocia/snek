require 'securerandom'

class Snake
  include ActiveModel::Serialization

  COLORS = ['#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe', '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#808080']

  attr_accessor :intent, :segments
  attr_reader :name, :uuid, :auth_token, :head, :last_intent, :color

  def initialize(name)
    @name = name
    @uuid = SecureRandom.uuid
    # Used to secure moves with the player
    @auth_token = SecureRandom.uuid
    @segments = []
    @color = COLORS.sample
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

  def to_game_hash
    {
      uuid: @uuid,
      name: @name,
      head: @head.position,
      length: length,
      body: @segments.map(&:position)
    }
  end

  def self.new_snakes
    members = $redis.smembers("new_snakes")

    if members.any?
      snakes = $redis.mget(members).compact.map{|data|
        Marshal.load(data)
      }
      $redis.del(members)

      snakes
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