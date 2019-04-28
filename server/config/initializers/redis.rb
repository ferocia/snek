$redis = Redis.new(
  url: ENV.fetch('REDIS_URL') {
    "redis://#{ENV["REDIS_HOST"] || "localhost"}:6379/#{Rails.env.test? ? 1 : 0}"
  }
)