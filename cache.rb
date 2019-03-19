require "redis"
class Cache
  @redis = Redis.new(host: ENV["REDIS_HOST"], port: ENV["REDIS_PORT"].to_i, db: ENV["REDIS_DB"].to_i)
  def self.fetch key, expires_in = 3600, &block
    if @redis.get(key)
      data = @redis.get(key)
      JSON.parse(data)
    else
      if block_given?
        value = yield(block)
        @redis.setex(key, expires_in.to_i, value.to_json)
        value
      else
        nil
      end
    end
  end
end