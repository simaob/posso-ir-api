# == Schema Information
#
# Table name: ranking_histories
#
#  id         :bigint           not null, primary key
#  position   :integer          not null
#  score      :integer          not null
#  user_id    :integer          not null
#  date       :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reports    :integer          default("0"), not null
#  places     :integer          default("0"), not null
#
class RankingHistory < ApplicationRecord
  belongs_to :user, optional: true

  validates :position, :score, :user_id, :date, presence: true

  scope :past_ranking, ->(date) { where(date: date) }
end
