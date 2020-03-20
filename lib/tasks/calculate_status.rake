namespace :status do
  desc 'Calculates the status for all stores'
  task calculate: :environment do
    StatusCrowdsource.find_each(&:calculate_status)
  end
end
