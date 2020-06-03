class OccupationUpdateJob < ApplicationJob
  queue_as :occupation

  def perform
    Sidekiq.logger.debug('Starting occupation update')
    ApaFetcher.occupation
    closing_time = Time.zone.parse('21:00')
    next_update = if Time.current.now >= closing_time
                    Time.zone.parse('8:00') + 1.day
                  else
                    Time.current + 15.minutes
                  end
    OccupationUpdateJob.set(wait_until: next_update)
      .perform_later
  end
end
