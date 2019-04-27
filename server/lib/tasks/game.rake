namespace :game do
  task :run => [:environment] do
    game = Game.new
    game.setup
    loop do
      game.tick
      ActionCable.server.broadcast 'viewer_channel', {state: game.to_s}
      sleep 1
    end
  end
end