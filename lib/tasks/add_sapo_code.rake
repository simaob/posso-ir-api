namespace :sapo_code do
  task add: :environment do
    file = Rails.root.join('db/files/sapo_mapper.csv').open
    CSV.new(file, headers: true, skip_blanks: true).each do |csv|
      beaches = Store.where(store_type: :beach)
        .where('district ilike ? AND county ilike ?', csv[0].titleize, csv[1].titleize)
      BeachConfiguration.where(store_id: beaches.pluck(:id))
        .update(sapo_code: csv[2])
    end
    file.close
  end

  task add_district: :environment do
    file = Rails.root.join('db/files/sapo_mapper.csv').open
    CSV.new(file, headers: true, skip_blanks: true).each do |csv|
      beaches = Store.where(store_type: :beach)
        .where('city ilike ?', csv[1].titleize)
      beaches.update(district: csv[0].titleize, county: csv[1].titleize)
    end
    file.close
  end
end
