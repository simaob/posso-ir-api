namespace :apa_fetcher do
  task water_quality: :environment do
    ApaFetcher.water_quality
  end

  task occupation: :environment do
    ApaFetcher.occupation
  end

  task set_jobs: :environment do
    OccupationUpdateJob.perform_later
    WaterQualityUpdateJob.perform_later
  end
end
