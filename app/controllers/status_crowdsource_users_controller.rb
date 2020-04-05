class StatusCrowdsourceUsersController < ApplicationController
  def index
    @statuses = StatusCrowdsourceUser.order(updated_at: :desc).page(params[:page])
  end
end
