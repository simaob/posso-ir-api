class WaterQualityUpdateJob < ApplicationJob
  queue_as :water_quality

  STARTING_TIME = '8:00'.freeze

  def perform
    Sidekiq.logger.debug('Starting water quality update')
    ApaFetcher.water_quality
    next_update = Time.zone.parse(STARTING_TIME) + 1.day
    WaterQualityUpdateJob.set(wait_until: next_update).perform_later
  end
end
