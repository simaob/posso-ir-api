class StatsController < ApplicationController
  def index
    authorize! :read, :stats
    @users_per_day = ::Api::Charts::Home.new.users_per_day
    @statuses_per_day = ::Api::Charts::Home.new.statuses_per_day
    @todays_stores_by_reports = Store.joins(:status_crowdsource_users)
      .select('stores.*, count(*) AS count')
      .where(status_crowdsource_users: {created_at: Time.current.beginning_of_day..Time.current.end_of_day})
      .group('stores.id')
      .order(count: :desc)
      .limit(15)
    @todays_users_by_reports = User.joins(:status_crowdsource_users)
      .select('users.*, count(*) AS count')
      .where(status_crowdsource_users: {created_at: Time.current.beginning_of_day..Time.current.end_of_day})
      .group('users.id')
      .order(count: :desc)
      .limit(15)
    @stores_by_reports = Store.joins(:status_crowdsource_users)
      .select('stores.*, count(*) AS count')
      .group('stores.id')
      .order(count: :desc)
      .limit(30)
    @users_by_reports = User.joins(:status_crowdsource_users)
      .select('users.*, count(*) AS count')
      .group('users.id')
      .order(count: :desc)
      .limit(30)
  end
end
