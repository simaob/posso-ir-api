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
#
class StatusCrowdsource < Status
  include TimeHelper
  has_many :status_crowdsource_users

  STATUS_PARAMS = {
    weight_now: 0.6,
    weight_before: 0.3,
    weight_long_before: 0.1
  }.freeze

  TIME_PARAMS = {
    first: 10,
    second: 20,
    third: 30
  }.freeze

  def calculate_status
    new_voters_status = new_votes
    new_voters = new_voters_status.count
    # If there's no new data, nothing is updated
    return if new_votes.none?

    voters_valid = TimeHelper.valid?(updated_time, TIME_PARAMS[:second])
    old_voters_valid = TimeHelper.valid?(previous_updated_time, TIME_PARAMS[:third])

    new_average_weighted = STATUS_PARAMS[:weight_now] * new_voters_status * new_voters rescue 0
    average_weighted = STATUS_PARAMS[:weight_before] * status * voters * voters_valid rescue 0
    old_average_weighted = STATUS_PARAMS[:weight_long_before] * previous_status * previous_voters * old_voters_valid rescue 0

    begin
      new_status =
        (new_average_weighted + average_weighted + old_average_weighted) / (
          (new_voters * STATUS_PARAMS[:weight_now]) +
          (voters * STATUS_PARAMS[:weight_before] * voters_valid) +
          (old_voters * STATUS_PARAMS[:weight_long_before] * old_voters_valid)
        )
    rescue
      new_status = nil
    end

    update(
      status: new_status,
      voters: new_voters,
      updated_time: DateTime.now,
      previous_status: status,
      previous_voters: voters,
      previous_updated_time: updated_time
    )
  end

  private

  def new_votes
    StatusCrowdsourceUser
      .where(store_id: store_id)
      .where("created_at > '#{ Time.now - TIME_PARAMS[:first] }'")
  end


end
