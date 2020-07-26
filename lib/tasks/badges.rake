namespace :badges do
  desc 'Creates initial badges'
  task create: :environment do
    [
      {name: 'welcome', target: 1, counter: 'daily_login_count'},
      {name: 'observer', target: 3, counter: 'daily_login_count'},
      {name: 'addicted', target: 10, counter: 'daily_login_count'},
      {name: 'noob', target: 1, counter: 'total_reports'},
      {name: 'novice', target: 5, counter: 'total_reports'},
      {name: 'experient', target: 10, counter: 'total_reports'},
      {name: 'veteran', target: 50, counter: 'total_reports'},
      {name: 'traveler', target: 5, counter: 'total_count'},
      {name: 'holidaymakers', target: 20, counter: 'beach_reports'},
      {name: 'beachy', target: 5, counter: 'beach_count'},
      {name: 'shoppingking', target: 20, counter: 'supermarket_reports'},
      {name: 'customer', target: 5, counter: 'supermarket_count'},
      {name: 'hypochondriac', target: 20, counter: 'pharmacy_reports'},
      {name: 'healer', target: 5, counter: 'pharmacy_count'},
      {name: 'glutton', target: 20, counter: 'restaurant_reports'},
      {name: 'dishwatcher', target: 5, counter: 'restaurant_count'}
    ].each do |badge|
      Badge.find_or_create_by(name: badge.titleize, slug: badge)
    end
    Rails.logger.info("We now have #{Badge.count} badges")
  end
end
