module TimeHelper
  def self.valid?(time, expiration)
    time > (Time.now - expiration.minutes) ? 1 : 0
  rescue TypeError
    0
  end
end