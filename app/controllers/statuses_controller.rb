class StatusesController < ApplicationController
  def index
    @statuses = Status.order(updated_at: :desc).page(params[:page])
    @statuses = @statuses.where(type: params[:type]) if params[:type].present?
  end
end
