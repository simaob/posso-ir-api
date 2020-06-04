class OccupationUpdateJob < ApplicationJob
  queue_as :occupation

  CLOSING_TIME = '22:00'.freeze
  STARTING_TIME = '06:00'.freeze

  def perform
    Sidekiq.logger.debug('Starting occupation update')
    ApaFetcher.occupation
    closing_time = Time.zone.parse(CLOSING_TIME)
    next_update = if Time.current >= closing_time
                    Time.zone.parse(STARTING_TIME) + 1.day
                  else
                    Time.current + 15.minutes
                  end
    OccupationUpdateJob.set(wait_until: next_update).perform_later
  end
end
