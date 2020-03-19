# == Schema Information
#
# Table name: statuses
#
#  id           :bigint           not null, primary key
#  updated_time :datetime         not null
#  valid_until  :datetime
#  status       :integer
#  queue_status :integer
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  store_id     :bigint
#
class StatusCrowdsource < Status
  has_many :status_crowdsource_users
end
