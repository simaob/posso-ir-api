# == Schema Information
#
# Table name: status_crowdsource_users
#
#  id         :bigint           not null, primary key
#  status     :integer          not null
#  queue      :integer
#  posted_at  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :bigint
#  user_id    :bigint
#
class StatusCrowdsourceUser < ApplicationRecord
  paginates_per 50
  belongs_to :user
  belongs_to :store

  validates :status, :inclusion => 0..10
end
