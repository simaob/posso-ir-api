class ImportStores
  def all
    cleanup
    import_auchan
    import_continente
    import_corte_ingles
    import_intermarche
    import_lidl
    import_mercadona
    import_minipreco
    import_pingodoce
    puts "#{Store.count} total stores"
  end

  def cleanup
    Store.delete_all
  end

  def import_auchan
    puts "Starting Auchan, we have #{Store.count} total stores"
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
    puts "#{Store.count} total stores"
  end

  def import_continente
    puts "Starting Continente, we have #{Store.count} total stores"
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
    puts "#{Store.count} total stores"
  end

  def import_corte_ingles
    puts "Starting Corte Inglés, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'elcorte.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file).each do |row|
      Store.create(
        name: row['name'],
        group: 'El Corte Inglés',
        country: 'PT',
        street: row['location'],
        latitude: nil,
        longitude: nil,
        details: row['time'],
        store_type: 1
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_intermarche
    puts "Starting Intermarché, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'intermarche.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file)['locations'].each do |row|
      Store.create(
        name: "Intermarché #{row['data-ga-label']}",
        group: 'Intermarché',
        country: 'PT',
        city: row['name'],
        street: row['data-search'],
        latitude: row['data-latitude'],
        longitude: row['data-longitude'],
        store_type: 1
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_lidl
    puts "Starting Lidl, we have #{Store.count} total stores"
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
    puts "#{Store.count} total stores"
  end

  def import_mercadona
    puts "Starting Mercadona, we have #{Store.count} total stores"
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
    puts "#{Store.count} total stores"
  end

  def import_minipreco
    puts "Starting Minipreço, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'minipreco.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')

    JSON.parse(file)['locations'].each do |row|
      Store.create(
        name: "Minipreço #{row['nombreVia'].titleize}",
        group: 'Minipreço',
        country: 'PT',
        city: row['localidad'].titleize,
        street: row['direccionPostal'].titleize,
        latitude: nil,
        longitude: nil,
        store_type: 1
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_pingodoce
    puts "Starting Pingo Doce, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'pingoDoce.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')

    JSON.parse(file)['stores'].each do |row|
      Store.create(
        name: "Pingo Doce #{row['name']}",
        group: 'Pingo Doce',
        country: 'PT',
        city: row['county'],
        street: row['address'],
        zip_code: row['postal_code'],
        latitude: row['lat'],
        longitude: row['long'],
        store_type: 1
      )
    end
    puts "#{Store.count} total stores"
  end
end
