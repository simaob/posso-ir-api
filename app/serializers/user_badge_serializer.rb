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
class UserBadgeSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash
  set_type :badge

  attribute :slug
  attribute :name
  attribute :date
end
