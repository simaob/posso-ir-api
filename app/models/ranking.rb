# == Schema Information
#
# Table name: rankings
#
#  id         :bigint           not null, primary key
#  position   :integer          not null
#  score      :integer          not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Ranking < ApplicationRecord
  belongs_to :user

  validates :position, :score, presence: true
end
