require 'action_cable_client'
require 'pry'

require_relative "./util/client.rb"
require_relative "./random_snake.rb"

SNEK_HOST = "localhost:3000"

$client = Client.new("http://#{SNEK_HOST}")

@snake_id = nil
@auth_token = nil
@map = $client.map

EventMachine.run do
  uri = "ws://#{SNEK_HOST}/cable"
  # We must send an Origin: header else rails is sad
  client = ActionCableClient.new(uri, 'ClientChannel', true, {'Origin' => "foo"})

  client.connected {
    puts 'successfully connected.'
  }

  client.received do |payload|
    puts "Received game state"

    game_state = payload.fetch("message")

    rando = game_state.fetch("alive_snakes").detect{|snake| snake.fetch("id") == @snake_id }

    if !rando
      # Oh no - there is no rando.  Let's make one
      response = $client.register_snake("Rando Carlrissian #{rand(123123)}")
      @snake_id = response.fetch("snake_id")
      @auth_token = response.fetch("auth_token")
    else
      # Yay - rando lives on - Let's get a move
      move = RandomSnake.new(rando, game_state, @map).get_intent
      puts "Moving #{move}"
      $client.set_intent(@snake_id, move, @auth_token)
    end
  end
end