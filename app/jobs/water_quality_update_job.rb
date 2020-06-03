class WaterQualityUpdateJob < ApplicationJob
  queue_as :water_quality

  def perform
    Sidekiq.logger.debug('Starting water quality update')
    ApaFetcher.water_quality
    next_update = Time.zone.parse('9:00') + 1.day
    WaterQualityUpdateJob.set(wait_until: next_update)
      .perform_later
  end
end
