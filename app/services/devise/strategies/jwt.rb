module Devise
  module Strategies
    class Jwt < Base
      def valid?
        request.headers['Authorization'].present?
      end

      def authenticate!
        payload = JwtService.decode(token: token)
        user = User.find_or_create_by(app_uuid: payload['uuid'])
        success! user
      rescue ::JWT::ExpiredSignature
        fail! 'Auth token has expired. Please login again'
      rescue ::JWT::DecodeError
        fail! 'Auth token is invalid'
      rescue
        fail!
      end

      private
      def token
        request.headers.fetch('Authorization', '').split(' ').last
      end
    end
  end
end

# Warden::Strategies.add(:jwt, Devise::Strategies::Jwt)
