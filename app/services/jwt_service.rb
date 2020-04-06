class JwtService
  ALGORITHM = 'HS256'.freeze

  def self.encode(payload:)
    JWT.encode(payload, secret, ALGORITHM)
  end

  def self.decode(token:)
    JWT.decode(token, secret, true, {algorithm: ALGORITHM}).first
  end

  def self.secret
    ENV['JWT_SECRET_KEY']
  end
end
