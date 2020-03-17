class ImportStores
  def call
    cleanup
    import_auchan
    import_continente
    import_corte_ingles
    import_intermarche
    import_lidl
    import_mercadona
    puts "#{Store.count} stores added"
  end

  def cleanup
    Store.delete_all
  end

  def import_auchan
    src = File.open(Rails.root.join('db', 'files', 'auchan.csv'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    CSV.parse(file, headers:true, skip_blanks: true). each do |csv|
      Store.create(
        name: csv['name'],
        country: 'PT',
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

  def import_corte_ingles
    src = File.open(Rails.root.join('db', 'files', 'elcorte.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file).each do |row|
      coordinates = Geocoder.search(row['location'])&.first&.coordinates

      Store.create(
        name: row['name'],
        group: 'El Corte Inglés',
        country: 'PT',
        street: row['location'],
        latitude: coordinates&.first,
        longitude: coordinates&.second,
        details: row['time'],
        store_type: 1
      )
    end
  end

  def import_intermarche
    src = File.open(Rails.root.join('db', 'files', 'intermarche.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file).each do |row|
      Store.create(
        name: "Intermarché #{row['name']}",
        group: 'Intermarché',
        country: 'PT',
        city: row['name'],
        street: row['location'],
        latitude: row['lat'],
        longitude: row['long'],
        store_type: 1
      )
    end
  end

  def import_lidl
    src = File.open(Rails.root.join('db', 'files', 'lidl.csv'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    CSV.parse(file, headers:true, skip_blanks: true). each do |csv|
      city, street = csv['name'].split('-')
      Store.create(
        name: "LIDL #{city.strip}",
        group: 'LIDL',
        city: city&.strip,
        street: street&.strip,
        latitude: csv['lat'],
        longitude: csv['lng'],
        store_type: 1
      )
    end
  end

  def import_mercadona
    src = File.open(Rails.root.join('db', 'files', 'mercadona.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file)['tiendasFull'].each do |row|
      Store.create(
        name: "Mercadona #{row['lc']}",
        group: 'Mercadona',
        country: row['p'],
        city: row['lc'].titleize,
        district: row['pv'].titleize,
        street: row['dr'].titleize,
        latitude: row['lt'],
        longitude: row['lg'],
        details: row['fs'],
        store_type: 1
      )
    end
  end
end
