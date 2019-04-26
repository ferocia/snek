class Tile
  attr_accessor :x, :y

  def initialize(x:, y:)
    @x = x
    @y = y
  end

  def inspect
    "."
  end
end