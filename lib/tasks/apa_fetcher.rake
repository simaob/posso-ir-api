namespace :apa_fetcher do
  task water_quality: :environment do
    ApaFetcher.water_quality
  end

  task occupation: :environment do
    ApaFetcher.occupation
  end

  task set_jobs: :environment do
    OccupationUpdateJob.set(wait_until: Time.current + 2.minutes).perform_later
    WaterQualityUpdateJob.set(wait_until: Time.current + 2.minutes).perform_later
  end
end
