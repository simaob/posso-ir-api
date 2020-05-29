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
class StatusStoreOwner < Status
  after_validation :set_valid_until
  validates :updated_time, :status, :store_id, presence: true
  after_create :update_general_status

  private

  def set_valid_until
    self.valid_until = updated_time + 2.hours rescue Time.current + 2.hours
  end

  def update_general_status
    StatusGeneral.find_by(store_id: store_id)&.update(
      updated_time: updated_time, status: status, queue: queue,
      valid_until: valid_until, voters: nil,
      is_official: true, estimation: false)
  end
end
