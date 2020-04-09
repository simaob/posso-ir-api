class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    return unless current_user&.admin? || current_user&.general_manager?

    @users_per_day = ::Api::Charts::Home.new.users_per_day
    @statuses_per_day = ::Api::Charts::Home.new.statuses_per_day
  end
end
