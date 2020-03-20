class ApiController < ApplicationController
  include JSONAPI::ActsAsResourceController

  skip_before_action :authenticate_user!
  before_action :authenticate_with_jwt!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def context
    { current_user: current_user }
  end

  private

  def authenticate_with_jwt!
    begin
      payload = JwtService.decode(token: token)
      if DateTime.parse(payload['expiration_date']) <= DateTime.now
        render json: {error: 'Auth token has expired. Please login again'}, status: 401
      else
        @current_user = User.find_or_create_by(app_uuid: payload['uuid'])
      end
    rescue
      render json: {error: 'not authorized'}, status: 401
    end
  end

  def current_user
    @current_user ||= User.find_by(app_uuid: JwtService.decode(token: token)['uuid'])
  rescue StandardError
    @current_user = nil
  end

  def token
    request.headers.fetch('Authorization', '').split(' ').last
  end
end
