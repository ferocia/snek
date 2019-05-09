namespace :game do
  task :run => [:environment] do
    $redis.flushdb
    Snake.delete_all
    game = Game.new
    game.setup
    loop do
      puts "Looping game state"
      game.tick
      ActionCable.server.broadcast 'viewer_channel', game
      sleep 1
    end
  end
end