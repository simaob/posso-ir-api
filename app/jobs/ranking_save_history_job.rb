class RankingSaveHistoryJob < ApplicationJob
  queue_as :ranking

  INTERVAL_MINUTES = 30

  def perform
    Sidekiq.logger.debug('Persisting ranking')

    RankingHistoryService.new.call
    next_update = Time.current.beginning_of_month + 1.month + 1.hour
    RankingUpdateJob.set(wait_until: next_update).perform_later

    Sidekiq.logger.debug('Finished persisting ranking')
  end
end
