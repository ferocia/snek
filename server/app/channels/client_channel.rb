# Events by players/clients are handled here
class ClientChannel < Channel
  def subscribed
    stream_from 'viewer_channel'
  end

  def unsubscribed
  end
end