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
class StatusCrowdsource < Status
  include TimeHelper
  has_many :status_crowdsource_users

  # TODO, this should be async! Move this to sidekiq+redis (or activejobs)
  after_update :create_history

  WEIGHT = {
    first: 0.6,
    second: 0.3,
    third: 0.1
  }.freeze

  TIME_PARAMS = {
    first: 11,
    second: 22,
    third: 33
  }.freeze

  def calculate_status
    votes = total_votes
    return unless votes.any?

    # We'll recalculate it for now
    # return if updated_time > votes.first.created_at

    first_votes = []
    second_votes = []
    third_votes = []
    first_time = (Time.now - TIME_PARAMS[:first].minutes).utc
    second_time = (Time.now - TIME_PARAMS[:second].minutes).utc

    votes.each do |v|
      case v.created_at
      when first_time...DateTime::Infinity.new
        first_votes << v
      when second_time...first_time
        second_votes << v
      else
        third_votes << v
      end
    end

    # The formula is: (sum_a*weight_a + sum_b*weight_b + sum_c*weight_c)/(count_a*weight_a + ...)

    first_voters = first_votes.count * WEIGHT[:first]
    second_voters = second_votes.count * WEIGHT[:second]
    third_voters = third_votes.count * WEIGHT[:third]
    first_results = first_votes.pluck(:status).reduce(:+).to_f * WEIGHT[:first]
    second_results = second_votes.pluck(:status).reduce(:+).to_f * WEIGHT[:second]
    third_results = third_votes.pluck(:status).reduce(:+).to_f * WEIGHT[:third]

    begin
      new_status = (first_results + second_results + third_results) / (first_voters + second_voters + third_voters)
    rescue StandardError
      return
    end

    update(
      status: new_status.round(2),
      voters: total_votes.count,
      updated_time: DateTime.now
    )
  end

  def calculate_status_new
    weight1 = 0.6
    weight2 = 0.3
    weight3 = 0.1
    cutoff1 = 11
    cutoff2 = 22
    cutoff3 = 33

    self.class.connection.execute <<SQL
    UPDATE statuses
    SET status = t.status,
      voters = t.voters,
      updated_time = '#{DateTime.now}',
      updated_at = '#{DateTime.now}'
    FROM (
      SELECT
        statuses.id AS id,
        ROUND((
          SUM(status_crowdsource_users.status * CASE
            WHEN status_crowdsource_users.created_at > NOW() - #{cutoff1} * INTERVAL '1 minute' THEN #{weight1}
            WHEN status_crowdsource_users.created_at > NOW() - #{cutoff2} * INTERVAL '1 minute' THEN #{weight2}
            ELSE #{weight3}
            END
          )
        ) / (
          SUM(CASE
            WHEN status_crowdsource_users.created_at > NOW() - #{cutoff1} * INTERVAL '1 minute' THEN #{weight1}
            WHEN status_crowdsource_users.created_at > NOW() - #{cutoff2} * INTERVAL '1 minute' THEN #{weight2}
            ELSE #{weight3}
            END
          )
        ), 2) AS status,
        COUNT(1) AS voters
      FROM statuses
      JOIN status_crowdsource_users ON statuses.store_id = status_crowdsource_users.store_id
      WHERE status_crowdsource_users.status IS NOT NULL
      AND status_crowdsource_users.created_at > NOW() - #{cutoff3} * INTERVAL '1 minute'
      GROUP BY statuses.id
    ) AS t
    WHERE t.id = statuses.id
    AND statuses.type = 'StatusCrowdsource'
    AND statuses.id = #{id}
SQL

    reload

    # TODO, this should be async! Move this to sidekiq+redis (or activejobs)
    create_history
  end

  private

  def total_votes
    StatusCrowdsourceUser
      .where(store_id: store_id)
      .where("created_at > '#{(Time.now - TIME_PARAMS[:third].minutes).utc.to_s(:db)}'")
      .where.not(status: nil)
      .order(created_at: :desc)
  end

  # Saves the current status into history
  def create_history
    StatusCrowdsourceHistory
      .create(updated_time: updated_time, valid_until: valid_until, status: status,
              queue: queue, store_id: store_id, voters: voters, is_official: is_official,
              old_created_at: created_at, old_updated_at: updated_at)
  end
end
