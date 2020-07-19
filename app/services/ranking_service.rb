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
        StatusCrowdsourceUser.joins(:user)
          .where.not(users: {confirmed_at: nil})
          .select('COUNT(*) as score, user_id ')
          .where('status_crowdsource_users.created_at > ?', Time.current.beginning_of_month)
          .group(:user_id)
          .order(score: :desc).to_a.each.with_index do |s, i|
          if s.count == previous_score
            Ranking.create(user_id: s.user_id, position: previous_position, score: s.score)
          else
            Ranking.create(user_id: s.user_id, position: s.position, score: s.score)
            previous_position = i
            previous_score = s.score
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
