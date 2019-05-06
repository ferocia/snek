class Position
  attr_accessor :x, :y

  def initialize(values)
    @x = values.fetch("x")
    @y = values.fetch("y")
  end

  def to_h
    {x: @x, y: @y}
  end

  def ==(other)
    @x == other.x && @y == other.y
  end
end