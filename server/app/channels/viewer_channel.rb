# View the game state here
class ViewerChannel < Channel
  def subscribed
    stream_from "viewer_channel"
  end

  def unsubscribed
  end
end