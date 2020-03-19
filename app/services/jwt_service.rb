class JwtService
  ALGORITHM = 'HS256'

  def self.encode(payload:)
    JWT.encode(payload, self.secret, ALGORITHM)
  end

  def self.decode(token:)
    JWT.decode(token, self.secret, true, { algorithm: ALGORITHM}).first
  end

  def self.secret
    ENV['JWT_SECRET_KEY']
  end
end
