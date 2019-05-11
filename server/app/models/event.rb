class Event
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def to_hash
    { type: type }
  end
end
