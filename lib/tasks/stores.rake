namespace :stores do
  desc 'Import stores into database'
  task import: :environment do
    ImportStores.new.call
  end
end
