require_relative './path_finder.rb'

p = PathFinder.new([
  [0,0,0,0,1],
  [1,1,0,1,1],
  [1,1,0,1,0],
  [1,1,0,1,0],
  [1,1,0,1,0],
  [1,1,1,1,0],
  [0,0,0,0,1]
])

journey = p.shortest_path(1,1,4,0)
raise 'incorrect' unless journey == [
  [1, 2],
  [1, 3],
  [1, 4],
  [1, 5],
  [2, 5],
  [3, 5],
  [3, 4],
  [3, 3],
  [3, 2],
  [3, 1],
  [4, 1],
  [4, 0]
]

raise 'incorrect' unless p.next_step_to_shortest_path(1,1,3,1) == 'S'
raise 'incorrect' unless p.next_step_to_shortest_path(1,1,4,5) == nil
raise 'incorrect' unless p.next_step_to_shortest_path(0,5,4,0) == 'E'

puts "Tests passed"
