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

  def calculate_status
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

  # Saves the current status into history
  def create_history
    StatusCrowdsourceHistory
      .create(updated_time: updated_time, valid_until: valid_until, status: status,
              queue: queue, store_id: store_id, voters: voters, is_official: is_official,
              old_created_at: created_at, old_updated_at: updated_at)
  end
end
