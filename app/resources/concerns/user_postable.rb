# frozen_string_literal: true

module UserPostable
  extend ActiveSupport::Concern

  USER_INTERVAL = 0.30
  DUPLICATE_REPORTS_INTERVAL = 30

  def validate_user_interval
    current_user = context[:current_user]
    return if current_user.admin?
    return if current_user.last_post.nil?
    return if current_user.last_post.utc < (Time.current - USER_INTERVAL.minutes) &&
      current_user.status_crowdsource_users.where(store_id: context[:store_id])
        .where('posted_at > ?', (Time.current - DUPLICATE_REPORTS_INTERVAL.minutes))
        .none?

    raise TooManyRequestsError
  end

  def update_user_time
    context[:current_user].update last_post: DateTime.current
  end
end
