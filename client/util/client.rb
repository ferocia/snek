class Client
  def initialize(url)
    @url = url
  end

  def register_snake(name)
    post("/register_snake", {name: name})
  end

  def set_intent(snake_id, intent, auth_token)
    post("/set_intent", {id: snake_id, intent: intent, auth_token: auth_token})
  end

  def map
    get("/map")
  end

  private

  def get(path)
    JSON.parse Net::HTTP.get(convert_to_uri("/map"))
  end

  def post(path, params)
    response = Net::HTTP.post_form(convert_to_uri(path), params)
    JSON.parse(response.body)
  end

  def convert_to_uri(path)
    URI.parse(@url + path)
  end
end