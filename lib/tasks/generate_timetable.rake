namespace :timetable do
  desc 'Generates timetables for all stores'
  task generate: :environment do

    UserStore.find_each do |us|
      GenerateTimetable.new.call(us.store)
    end
  end
end