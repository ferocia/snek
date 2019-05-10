# Events by players/clients are handled here
class ClientChannel < Channel
  def subscribed
    stream_from 'client_channel'
  end

  def unsubscribed
  end
end