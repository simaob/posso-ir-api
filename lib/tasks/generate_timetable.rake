namespace :timetable do
  desc 'Generates timetables for all stores'
  task generate: :environment do

    Store.where(timetable)
  end
end