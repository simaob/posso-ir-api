namespace :apa_fetcher do
  task water_quality: :environment do
    ApaFetcher.water_quality
  end

  task occupation: :environment do
    ApaFetcher.occupation
  end
end
