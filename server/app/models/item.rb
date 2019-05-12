class Item < ApplicationRecord
  validates :item_type, inclusion: ["food", "dead_snake"]

  def tile
    Position.new(position)
  end

  def duration
    if food?
      5
    elsif dead_snake?
      10
    end
  end

  def to_pickup
    {item_type: item_type, turns_left: duration}
  end

  def food?
    item_type == 'food'
  end

  def dead_snake?
    item_type == 'dead_snake'
  end
end
