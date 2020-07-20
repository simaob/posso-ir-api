# == Schema Information
#
# Table name: user_badges
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  badge_id   :bigint           not null
#  date       :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserBadge < ApplicationRecord
  belongs_to :user
  belongs_to :badge

  delegate :slug, :name, to: :badge
end
