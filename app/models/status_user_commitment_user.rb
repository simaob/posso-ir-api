# == Schema Information
#
# Table name: status_user_commitment_users
#
#  id         :bigint           not null, primary key
#  status     :integer          not null
#  posted_at  :datetime         not null
#  start_at   :datetime
#  duration   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :bigint
#  user_id    :bigint
#
class StatusUserCommitmentUser < ApplicationRecord
  belongs_to :user
  belongs_to :status_user_commitment
end
