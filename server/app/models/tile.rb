class Tile
  attr_accessor :x, :y, :type

  def initialize(x:, y:, type:)
    @x = x
    @y = y
    @type = type
  end

  def inspect
    "<#{x},#{y} - #{to_s}>"
  end

  def to_s
    if wall?
      '#'
    else
      '.'
    end
  end

  def wall?
    @type == :wall
  end
end