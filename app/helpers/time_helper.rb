module TimeHelper
  def self.valid?(time, expiration)
    time.utc > (Time.current - expiration.minutes) ? 1 : 0
  rescue TypeError, NoMethodError
    0
  end
end
