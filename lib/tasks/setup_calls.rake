namespace :phone_calls do
  desc 'Adds the phone calls to activejob'
  task setup: :environment do
    CallSetupService.new.call
  end
end
