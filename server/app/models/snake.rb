require 'securerandom'

class Snake < ApplicationRecord
  COLORS = ['#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe', '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#808080']
  VALID_MOVES = ['N', 'S', 'E', 'W']

  validates :name, presence: true
  validates :intent, inclusion: VALID_MOVES, allow_blank: true

  before_create :setup_snake

  def self.new_snakes
    where(head_position: nil)
  end

  def self.alive
    where.not(head_position: nil)
  end

  def setup_snake
    # Used to secure moves with the player
    self.auth_token = SecureRandom.uuid
    self.last_intent = VALID_MOVES.sample
    self.color = COLORS.sample
  end

  def head
    Position.new(self.head_position)
  end

  def segments
    self.segment_positions.map{|sp|
      Position.new(sp)
    }
  end

  def set_position(initial_tile)
    self.head_position = initial_tile.to_h
    save!
  end

  def move(new_tile, should_grow)
    segment_positions.unshift head_position
    segment_positions.pop unless should_grow
    self.head_position = new_tile.to_h
    self.last_intent = self.intent || self.last_intent
    self.intent = nil
    save!
  end

  def length
    segments.count + 1
  end

  def occupied_space
    [head] + segments
  end

  def to_game_hash
    {
      id: id,
      name: name,
      head: head,
      color: color,
      length: length,
      body: segments
    }
  end
end