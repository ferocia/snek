require 'action_cable_client'

SNEK_HOST = "localhost:3000"

EventMachine.run do
  uri = "ws://#{SNEK_HOST}/cable"
  # We must send an Origin: header else rails is sad
  client = ActionCableClient.new(uri, 'ClientChannel', true, {'Origin' => "foo"})


  # called whenever a welcome message is received from the server
  client.connected { puts 'successfully connected.' }

  # called whenever a message is received from the server
  client.received do | message |
    puts message
  end

  # Sends a message to the sever, with the 'action', 'speak'
  client.perform('speak', { message: 'hello from amc' })
end