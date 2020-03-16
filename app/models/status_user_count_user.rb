# == Schema Information
#
# Table name: status_user_count_users
#
#  id           :bigint           not null, primary key
#  status       :integer          not null
#  queue_status :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  store_id     :bigint
#  user_id      :bigint
#
class StatusUserCountUser < ApplicationRecord
  belongs_to :user
  belongs_to :status_user_count
end
