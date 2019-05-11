class Item < ApplicationRecord
  validates :item_type, inclusion: ["food"]

  def tile
    Position.new(position)
  end

  def duration
    if food?
      5
    end
  end

  def to_pickup
    {item_type: item_type, turns_left: duration}
  end

  def food?
    item_type == 'food'
  end
end
