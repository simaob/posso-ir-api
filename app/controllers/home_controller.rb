class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    return unless current_user&.admin? || current_user&.general_manager?

    @users_per_day = ::Api::Charts::Home.new.users_per_day
    @statuses_per_day = ::Api::Charts::Home.new.statuses_per_day
    @stores_by_reports = Store.joins(:status_crowdsource_users)
      .select('stores.*, count(*) AS count')
      .group('stores.id')
      .order(count: :desc)
      .limit(50)
    @users_by_reports = User.joins(:status_crowdsource_users)
      .select('users.*, count(*) AS count')
      .group('users.id')
      .order(count: :desc)
      .limit(50)
  end
end
