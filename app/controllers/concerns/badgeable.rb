module Badgeable
  extend ActiveSupport::Concern

  def random_badges_for(user)
    user.user_badges.destroy_all
    Badge.all.sample(rand(1..5)).each do |badge|
      user.user_badges << UserBadge.new(badge_id: badge.id, date: rand(1..2).days.ago)
    end
  end
end
