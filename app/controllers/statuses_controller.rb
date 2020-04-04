class StatusesController < ApplicationController
  def index
    @statuses = Status.order(updated_at: :desc).page(params[:page])
  end
end
