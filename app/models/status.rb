# == Schema Information
#
# Table name: statuses
#
#  id                    :bigint           not null, primary key
#  updated_time          :datetime         not null
#  valid_until           :datetime
#  status                :float
#  queue                 :integer
#  type                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  store_id              :bigint
#  previous_status       :float
#  previous_queue        :float
#  previous_updated_time :datetime
#  voters                :integer
#  previous_voters       :integer
#  is_official           :boolean          default("false")
#  active                :boolean          default("true")
#  estimation            :boolean          default("false")
#
class Status < ApplicationRecord
  paginates_per 100
  belongs_to :store

  validates :status, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10}, allow_blank: true
  validates :updated_time, presence: true
end
