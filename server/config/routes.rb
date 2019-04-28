Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  post '/register_snake', to: "snake#register_snake"
  post '/set_intent',     to: "snake#set_intent"
  root to: "game#index"
end
