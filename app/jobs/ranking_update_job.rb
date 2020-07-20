class RankingUpdateJob < ApplicationJob
  queue_as :ranking

  INTERVAL_MINUTES = 30

  def perform
    Sidekiq.logger.debug('Updating ranking')

    RankingService.new.call
    next_update = Time.current + INTERVAL_MINUTES.minutes
    RankingUpdateJob.set(wait_until: next_update).perform_later

    Sidekiq.logger.debug('Finished updating ranking')
  end
end
