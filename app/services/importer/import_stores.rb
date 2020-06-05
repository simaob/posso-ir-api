module Importer
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
      Rails.logger.info "#{Store.count} total stores"
    end

    def cleanup
      Store.delete_all
    end

    def import_aldi
      import 'Aldi', 'aldi.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8')).each do |key, row|
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
      end
    end

    def import_apolonia
      import 'Apolonia', 'apolonia.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['stores'].each do |row|
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
      end
    end

    def import_auchan
      import 'Auchan', 'auchan.csv' do |file|
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
      end
    end

    def import_continente
      import 'Continente', 'continente.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['response']['locations'].each do |row|
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
      end
    end

    def import_corte_ingles
      import 'Corte Inglés', 'elcorte.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8')).each do |row|
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
      end
    end

    def import_coviran
      import 'Coviran', 'coviran.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['stores'].each do |row|
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
      end
    end

    def import_eleclerc
      import 'Eleclerc', 'eleclerc.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['locations'].each do |row|
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
      end
    end

    def import_froiz
      import 'Froiz', 'froiz.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['stores']['marker'].each do |row|
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
      end
    end

    def import_intermarche
      import 'Intermarché', 'intermarche.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['locations'].each do |row|
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
      end
    end

    def import_lidl
      import 'Lidl', 'lidl.csv' do |file|
        CSV.new(file, headers: true, skip_blanks: true).each do |csv|
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
      end
    end

    def import_mercadona
      import 'Mercadona', 'mercadona.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['tiendasFull'].each do |row|
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
      end
    end

    def import_minipreco
      import 'Minipreço', 'minipreco.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['locations'].each do |row|
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
      end
    end

    def import_pingodoce
      import 'Pingo Doce', 'pingoDoce.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['stores'].each do |row|
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
      end
    end

    def import_spar
      import 'Spar', 'spar.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['1'].each do |_, row|
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
      end
    end

    def import_pharmacies
      import 'Pharmacies', 'farmacias.csv' do |file|
        CSV.new(file, headers: true, skip_blanks: true).each do |csv|
          next if csv[15].blank?

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
      end
    end

    def import_prio
      import 'Prio', 'postos_prio.csv' do |file|
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
      end
    end

    def import_dia
      import 'Dia', 'dia.csv' do |file|
        CSV.new(file, headers: true, skip_blanks: true).each do |csv|
          next if csv[9].blank?

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
      end
    end

    def import_from_osm
      import 'OSM import', 'osm_export.csv' do |file|
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
      end
    end

    def import_spanish_stores
      import 'Spanish stores import', 'stores_spain.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8')).each do |row|
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
      end
    end

    def import_continente_from_api
      import 'Continente from api import', 'continente.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8'))['response']['locations'].each do |row|
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
      end
    end

    def import_meu_super
      import 'Meu Super', 'meu_super.json' do |file|
        JSON.parse(file.read.force_encoding('UTF-8')).each do |row|
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
      end
    end

    private

    def import(store_name, filename)
      Rails.logger.info "Starting #{store_name}, we have #{Store.count} total stores"

      file = Rails.root.join('db/files', filename).open

      yield file

      file.close

      Rails.logger.info "#{Store.count} total stores"
    end
  end
end
