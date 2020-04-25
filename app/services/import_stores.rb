class ImportStores
  def all
    cleanup
    import_aldi
    import_apolonia
    import_auchan
    import_continente
    import_corte_ingles
    import_coviran
    import_eleclerc
    import_froiz
    import_intermarche
    import_lidl
    import_mercadona
    import_dia
    import_pingodoce
    import_spar
    import_pharmacies
    import_prio
    import_from_osm
    import_spanish_stores
    import_continente_from_api
    import_meu_super
    puts "#{Store.count} total stores"
  end

  def cleanup
    Store.delete_all
  end

  def import_aldi
    puts "Starting Aldi, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'aldi.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file).each do |key, row|
      row = row.first
      Store.create(
        name: row['name'],
        group: 'Aldi',
        country: 'PT',
        city: row['addressLocality'],
        district: key,
        zip_code: row['postalCode'],
        street: row['address'],
        latitude: nil,
        longitude: nil,
        store_type: :supermarket
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_apolonia
    puts "Starting Apolonia, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'apolonia.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file)['stores'].each do |row|
      Store.create(
        name: row['name'],
        group: 'Apolónia',
        country: 'PT',
        city: row['name'].split(' ').last,
        district: nil,
        zip_code: nil,
        street: row['address'],
        latitude: row['lat'],
        longitude: row['lng'],
        store_type: :supermarket
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_auchan
    puts "Starting Auchan, we have #{Store.count} total stores"
    file = File.open(Rails.root.join('db', 'files', 'auchan.csv'), 'r')
    CSV.new(file, headers: true, skip_blanks: true).each do |csv|
      Store.create(
        name: csv['name'],
        country: 'PT',
        group: 'Auchan',
        city: csv['city'],
        latitude: csv['lat'],
        longitude: csv['lng'],
        store_type: :supermarket
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_continente
    puts "Starting Continente, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'continente.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file)['response']['locations'].each do |row|
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
        store_type: :supermarket
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
        store_type: :supermarket
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_coviran
    puts "Starting Coviran, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'coviran.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file)['stores'].each do |row|
      city = row['address'].split(',')[1].strip.titleize
      Store.create(
        name: [row['title'], city].join(' - '),
        group: 'Coviran',
        country: 'PT',
        city: city,
        district: nil,
        zip_code: nil,
        street: row['address'].split(',').map(&:strip).join(','),
        latitude: row['lat'],
        longitude: row['lng'],
        store_type: :supermarket
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_eleclerc
    puts "Starting Eleclerc, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'eleclerc.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file)['locations'].each do |row|
      Store.create(
        name: "Eleclerc #{row[0]}",
        group: 'Eleclerc',
        country: 'PT',
        city: row[0].gsub('Hipermercado', '').strip.titleize,
        district: nil,
        zip_code: nil,
        street: nil,
        latitude: row[1],
        longitude: row[2],
        details: row.last,
        store_type: :supermarket
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_froiz
    puts "Starting Froiz, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'froiz.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file)['stores']['marker'].each do |row|
      Store.create(
        name: "Froiz #{row['-direccion'].split(' - ')[row['-direccion'].size - 2]}",
        group: 'Froiz',
        country: 'PT',
        city: row['-direccion'].split(' - ').last,
        district: nil,
        zip_code: nil,
        street: nil,
        latitude: row['-lat'],
        longitude: row['-lng'],
        details: [row['-horario'], row['horariodom']].compact.join(' | '),
        store_type: :supermarket
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
        store_type: :supermarket
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_lidl
    puts "Starting Lidl, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'lidl.csv'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    CSV.parse(file, headers: true, skip_blanks: true).each do |csv|
      Store.create(
        name: "LIDL #{csv[1]}",
        group: 'LIDL',
        street: csv[2],
        zip_code: csv[3],
        city: csv[4],
        district: csv[5],
        country: 'Portugal',
        latitude: csv[7],
        longitude: csv[8],
        store_type: :supermarket
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
        store_type: :supermarket
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
        store_type: :supermarket
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
        store_type: :supermarket
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_spar
    puts "Starting Spar, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'spar.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file)['1'].each do |_, row|
      Store.create(
        name: row['title'],
        group: 'Spar',
        country: 'PT',
        city: nil,
        street: row['address'],
        zip_code: nil,
        latitude: row['lat'],
        longitude: row['lng'],
        store_type: :supermarket
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_pharmacies
    puts "Starting Pharmacies, we have #{Store.count} total stores"
    file = File.open(Rails.root.join('db', 'files', 'farmacias.csv'), 'r')
    CSV.new(file, headers: true, skip_blanks: true).each do |csv|
      next unless csv[15].present?

      Store.create(
        name: "Farmácia #{csv[1].titleize}",
        group: 'Farmácias',
        country: 'PT',
        city: csv[7],
        district: csv[8],
        street: csv[5],
        zip_code: csv[6],
        latitude: csv[15].split(', ')[0],
        longitude: csv[15].split(', ')[1],
        store_type: 2
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_prio
    puts "Starting Prio, we have #{Store.count} total stores"
    file = File.open(Rails.root.join('db', 'files', 'postos_prio.csv'), 'r')
    CSV.new(file, headers: true, skip_blanks: true).each do |csv|
      Store.create(
        name: "Prio #{csv[0].titleize}",
        group: 'Prio',
        country: 'PT',
        district: csv[8],
        street: csv[7],
        latitude: csv[5],
        longitude: csv[6],
        store_type: :gas_station,
        open: csv[1] == 'Sim'
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_dia
    puts "Starting Dia, we have #{Store.count} total stores"
    file = File.open(Rails.root.join('db', 'files', 'dia.csv'), 'r')
    CSV.new(file, headers: true, skip_blanks: true).each do |csv|
      next unless csv[9].present?

      Store.create(
        name: "#{csv[3].titleize} #{csv[2].titleize}",
        group: 'Dia',
        country: 'PT',
        district: csv[4],
        city: csv[6],
        street: csv[7],
        zip_code: csv[8],
        latitude: csv[9].split(',')[0].strip,
        longitude: csv[9].split(',')[1].strip,
        store_type: :supermarket
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_from_osm
    puts "Starting OSM Import, we have #{Store.count} total stores"
    file = File.open(Rails.root.join('db', 'files', 'osm_export.csv'), 'r')
    CSV.new(file, headers: true, skip_blanks: true).each do |csv|
      Store.create(
        name: csv[0],
        country: 'Portugal',
        latitude: csv[1],
        longitude: csv[2],
        store_type: csv[3].to_i,
        from_osm: true
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_spanish_stores
    puts "Starting Spanish Stores Import, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'stores_spain.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file).each do |row|
      Store.create(
        name: row['storeName'],
        group: row['businessName'],
        country: 'España',
        city: row['city'],
        street: row['address'],
        zip_code: row['postalCode'],
        latitude: row['lat'],
        longitude: row['lon'],
        store_type: :supermarket,
        source: 'Tiendo'
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_continente_from_api
    puts "Starting Continente from api import, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'continente.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file)['response']['locations'].each do |row|
      Store.create(
        name: row['name'],
        group: 'Continente',
        country: 'Portugal',
        city: row['city'],
        district: row['province'],
        original_id: row['id'],
        street: row['streetAndNumber'],
        zip_code: row['zip'],
        latitude: row['lat'],
        longitude: row['lng'],
        store_type: :supermarket,
        source: 'Uberall-Sonae'
      )
    end
    puts "#{Store.count} total stores"
  end

  def import_meu_super
    puts "Starting Meu Super from api import, we have #{Store.count} total stores"
    src = File.open(Rails.root.join('db', 'files', 'meu_super.json'), 'r')
    file = File.read(src).force_encoding('UTF-8')
    JSON.parse(file).each do |row|
      interm = row['morada'].split(', ')
      zip_code = interm.pop
      morada = interm
      Store.create(
        name: "Meu Super #{row['name']}",
        group: 'Meu Super',
        country: 'Portugal',
        original_id: row['id'],
        street: morada.join(', '),
        zip_code: zip_code,
        latitude: row['latitude'],
        longitude: row['longitude'],
        details: row['horarios'],
        store_type: :supermarket,
        source: 'MeuSuper-Website'
      )
    end
    puts "#{Store.count} total stores"
  end
end
