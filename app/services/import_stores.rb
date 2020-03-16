class ImportStores
  def call
    cleanup
    import_auchan
    import_continente
    puts "#{Store.count} stores added"
  end

  def cleanup
    Store.delete_all
  end

  def import_auchan
    src = File.open(Rails.root.join('db', 'files', 'AUCHAN.csv'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    CSV.parse(file, headers:true, skip_blanks: true). each do |csv|
      Store.create(
        name: csv['name'],
        group: 'Auchan',
        city: csv['city'],
        latitude: csv['lat'],
        longitude: csv['lng'],
        store_type: 1
      )
    end
  end

  def import_continente
    src = File.open(Rails.root.join('db', 'files', 'continente.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file)["response"]["locations"].each do |row|
      Store.create(
        name: row['name'],
        group: 'Continente',
        country: row['country'],
        city: row['city'],
        district: row['province'],
        zip_code: row['zip'],
        street: row['streetAndNumber'],
        latitude: row['lat'],
        longitude: row['lng'],
        store_type: 1
      )
    end
  end
end
