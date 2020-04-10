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
#
class StatusGeneral < Status
  after_update :create_history

  private

  def create_history
    StatusGeneralHistory
      .create(updated_time: updated_time, valid_until: valid_until, status: status,
              queue: queue, store_id: store_id, voters: voters, is_official: is_official,
              old_created_at: created_at, old_updated_at: updated_at)
  end
end
