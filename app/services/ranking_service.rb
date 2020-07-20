class RankingService
  def log(msg)
    Rails.logger.info msg
  end

  def initialize(options = {})
    options.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def call
    duration = Benchmark.ms do
      log 'Calculating the Rankings'
      Ranking.transaction do
        Ranking.delete_all

        previous_score = -1
        previous_position = -1
        query = <<~SQL
          SELECT 3 * COUNT(*) + SUM(sub.reports) as score, SUM(sub.reports) as reports, COUNT(*) as places, sub.user_id
          FROM
              (
              SELECT COUNT(*) as reports, user_id, store_id
              FROM status_crowdsource_users
              WHERE status_crowdsource_users.created_at > '#{Time.current.beginning_of_month}'
              GROUP BY user_id, store_id) as sub
          JOIN users ON users.id = sub.user_id AND users.confirmed_at IS NOT NULL
          GROUP BY sub.user_id
          ORDER BY score DESC
        SQL

        ranks = ActiveRecord::Base.connection.execute query
        ranks.to_a.each.with_index do |s, i|
          if s['score'] == previous_score
            Ranking.create(user_id: s['user_id'], position: previous_position,
                           score: s['score'], reports: s['reports'], places: s['places'])
          else
            Ranking.create(user_id: s['user_id'], position: i + 1, score: s['score'],
                           reports: s['reports'], places: s['places'])
            previous_position = i + 1
            previous_score = s['score']
          end
        end
      end
    end
    log "Finished calculating the rankings in #{duration} ms"
  end

  private

  # TODO: Define this. Users must belong to countries
  attr_reader :country
end
