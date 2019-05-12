# Finds the shortest path from one node to another in
# a simple matrix.
# Uses a modified version of the
# Lee algorithm (https://en.wikipedia.org/wiki/Lee_algorithm),
# tweaked to retain the path, rather than just calculate the distance.
class PathFinder

  Node = Struct.new(:x, :y, :dist, :parent)

  # `matrix` must be an array of arrays which
  # represent the rows and columns of the board.
  # 0 represents a square that cannot be pathed.
  # 1 represents a square that can be pathed.
  #
  # [
  #   [0,0,0,0,1],
  #   [1,1,0,1,1],
  #   [1,1,0,1,0],
  #   [1,1,0,1,0],
  #   [1,1,0,1,0],
  #   [1,1,1,1,0],
  #   [0,0,0,0,1]
  # ]
  def initialize(matrix)
    @matrix = matrix
  end

  # returns the first step of the journey to the shortest path
  # between from_x,from_y to to_x, to_y, in the form of
  # `N`, `S`, `E`, `W`, or `nil` if no path can be found.
  def next_step_to_shortest_path(from_x, from_y, to_x, to_y)
    move = shortest_path(from_x, from_y, to_x, to_y)&.first
    return nil unless move
    if move[0] == from_x && move[1] == from_y + 1
      return 'S'
    elsif move[0] == from_x && move[1] == from_y - 1
      return 'N'
    elsif move[0] == from_x + 1 && move[1] == from_y
      return 'E'
    elsif move[0] == from_x - 1 && move[1] == from_y
      return 'W'
    end
    raise 'This should not happen'
  end

  # Returns the shortest path from from_x,from_y to to_x, to_y
  # as an array of 2 element [x,y] arrays...
  # or `nil` if no path can be found
  def shortest_path(from_x, from_y, to_x, to_y)
    @visited = Array.new(@matrix.size) { Array.new(@matrix.first.size) { false } }
    queue = Queue.new
    queue << Node.new(from_x, from_y, 0)

    while !queue.empty? do
      node = queue.pop
      if node.x == to_x && node.y == to_y
        # We pathed to the target
        target_node = node
        break
      end
      [[-1,0],[1,0],[0,1],[0,-1]].each do |dir|
        x = node.x + dir[0]
        y = node.y + dir[1]
        if is_valid?(x, y)
          @visited[y][x] = true
          queue.push(Node.new(x, y, node.dist + 1, node))
        end
      end
    end

    # We didn't find a path to the target
    return nil unless target_node

    # Trace back the journey
    journey = []
    journey.push [node.x,node.y]
    while !node.parent.nil? do
      node = node.parent
      journey.push [node.x,node.y]
    end
    journey.reverse.drop(1)
  end

  # Is this a valid node that we haven't pathed to before?
  def is_valid?(x, y)
    return false if x < 0 || x >= @matrix.first.length
    return false if y < 0 || y >= @matrix.length
    return false unless @matrix[y][x] == 1
    return false if @visited[y][x]
    true
  end

end
