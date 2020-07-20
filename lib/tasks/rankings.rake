namespace :rankings do
  task set_jobs: :environment do
    RankingUpdateJob.set(wait_until: Time.current + 2.minutes).perform_later
    RankingSaveHistoryJob.set(wait_until: Time.current.beginning_of_month + 1.month + 1.hour).perform_later
  end
end
