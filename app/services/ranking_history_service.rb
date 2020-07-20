class RankingHistoryService
  def log(msg)
    Rails.logger.info msg
  end

  def call
    duration = Benchmark.ms do
      log 'Calculating the Rankings'
      RankingHistory.transaction do
        Ranking.find_each do |r|
          RankingHistory.create(user_id: r.user_id,
                                position: r.position,
                                score: r.score,
                                reports: r.reports,
                                places: r.places,
                                date: Time.zone.today)
        end
      end
    end
    log "Finished copying the rankings in #{duration} ms"
  end
end
