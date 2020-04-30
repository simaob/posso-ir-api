# == Schema Information
#
# Table name: statuses
#
#  id                    :bigint           not null, primary key
#  updated_time          :datetime         not null
#  valid_until           :datetime
#  status                :float
#  type                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  store_id              :bigint
#
class StatusEstimation < Status
  after_update :create_history
  after_update :update_status_general

  private

  def create_history
    StatusEstimationHistory
      .create(updated_time: updated_time, valid_until: valid_until, status: status,
              store_id: store_id, old_created_at: created_at, old_updated_at: updated_at)
  end

  def update_status_general
    general = StatusGeneral.find_by(store_id: store_id)
    return unless general.updated_time
    return if general.updated_time + 1.hour > updated_time

    general.update updated_time: updated_time, status: status,
                   valid_until: valid_until, estimation: true,
                   is_official: false
  end
end
