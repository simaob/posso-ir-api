namespace :status do
  desc 'Calculates the status for all stores'
  task calculate: :environment do
    CalculateStatus.new.call
  end
end
