Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  post '/register_snake', to: "game_state#register_snake"
  post '/set_intent',     to: "game_state#set_intent"
  get '/map',             to: "game_state#map"
  root to: "game#index"
end
