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
require 'rails_helper'

RSpec.describe UserBadge, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
