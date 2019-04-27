namespace :game do
  task :run => [:environment] do
    game = Game.new
    game.setup
    loop do
      game.tick
      ActionCable.server.broadcast 'viewer_channel', game
      sleep 1
    end
  end
end