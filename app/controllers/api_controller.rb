class ApiController < ApplicationController
  include JSONAPI::ActsAsResourceController

  before_action :authenticate_with_jwt!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  private

  def authenticate_with_jwt!
    warden.authenticate!(:jwt)
  end
end
