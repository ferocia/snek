namespace :game do
  task :run => [:environment] do
    $redis.flushdb
    Snake.delete_all
    game = Game.new
    game.setup(width: 40, height: 40)
    loop do
      puts "Looping game state"
      time = Time.now
      game.tick
      puts "Done - #{Time.now - time}"
      ActionCable.server.broadcast 'viewer_channel', game
      sleep 1
    end
  end
end