module Badgeable
  extend ActiveSupport::Concern

  def random_badges_for(user)
    user.user_badges.destroy_all
    [:welcome, :observer, :addicted, :noob, :beginner].sample(rand(1..5)).each do |badge|
      bdg = Badge.find_or_create_by(slug: badge, name: badge.to_s.titleize)
      user.user_badges << UserBadge.new(badge_id: bdg.id, date: rand(1..2).days.ago)
    end
  end
end

