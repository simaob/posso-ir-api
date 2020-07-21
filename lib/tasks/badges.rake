namespace :badges do
  desc 'Creates initial badges'
  task create: :environment do
    %w(
      welcome
      observer
      addicted
      noob
      novice
      experient
      veteran
      traveler
      holidaymakers
      beachy
      customer
      hypochondriac
      glutton
    ).each do |badge|
      Badge.find_or_create_by(name: badge.titleize, slug: badge)
    end
    Rails.logger.info("We now have #{Badge.count} badges")
  end
end
