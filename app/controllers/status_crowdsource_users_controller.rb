class StatusCrowdsourceUsersController < ApplicationController
  def index
    @status_crowdsource_users = StatusCrowdsourceUser.order(updated_at: :desc)
      .page(params[:page])
  end
end
