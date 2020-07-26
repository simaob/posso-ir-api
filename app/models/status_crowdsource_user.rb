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

  validates :status, inclusion: 0..10

  after_create :update_status_crowdsource

  private

  def update_status_crowdsource
    # TODO: This is hardcoded. It should be somewhere else (and synched with the front)
    # return if StatusGeneral.where(store_id: store_id).where('valid_until < ?', Time.current).any?
    return if StatusGeneral.where(store_id: store_id).where('updated_time > ?', Time.current - 1.hour).any?

    StatusCrowdsource.find_by(store_id: store_id).update(updated_time: Time.current, status: status, voters: 1)
    StatusGeneral.find_or_initialize_by(store_id: store_id).update(updated_time: Time.current,
                                                     status: status,
                                                     voters: 1,
                                                     is_official: false)
  end
end
