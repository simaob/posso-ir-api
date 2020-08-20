module Importer
  class ImportBeaches
    include HTTParty

    base_uri 'infopraiaapi.apambiente.pt'

    def all
      cleanup
      import_beaches_deco
      import_beaches_apa
      Rails.logger.info "#{Store.where(store_type: :beach).count} total stores"
    end

    def cleanup
      Store.where(store_type: :beach).delete_all
    end

    def update_beaches_apa
      data = self.class.get('/perfil.json')&.body
      count_updates = 0
      missing_beaches = 0
      JSON.parse(data)['features'].each do |item|
        beach = item['attributes']
        store = Store.find_by(original_id: beach['id'], source: 'APA', store_type: :beach)
        if !store
          missing_beaches += 1
          next
        else
          count_updates += 1
        end

        store.name = beach['praia']
        store.country =  'Portugal'
        store.latitude = beach['latitude']
        store.longitude = beach['longitude']
        beach_conf = store.beach_configuration

        beach_conf.code = beach['code']&.to_s
        beach_conf.water_code = beach['codigo_agua_balnear']
        beach_conf.guarded = beach['vigilancia']
        beach_conf.first_aid_station = beach['posto_socorros']
        beach_conf.wc = beach['sanitarios']
        beach_conf.showers = beach['duche']
        beach_conf.garbage_collection = beach['recolha_lixo']
        beach_conf.cleaning = beach['limpeza_praia']
        beach_conf.info_panel = beach['painel_informativo']
        beach_conf.bathing_support = beach['apoio_balnear']
        beach_conf.beach_support = beach['apoio_praia']
        beach_conf.parking = beach['estacionamento']
        beach_conf.quality_flag = beach['bandeira_azul']
        beach_conf.accessibility = beach['acessivel']
        beach_conf.water_chair = beach['cadeira_anfibia']
        beach_conf.construction = beach['obras_em_curso']
        beach_conf.collapsing_risk = beach['risco_derrocada']
        beach_conf.season_start = Date.parse("06/06/#{Date.current.year}")
        beach_conf.season_end = Date.parse("30/09/#{Date.current.year}")

        beach_conf.save
        store.save
      end
      Rails.logger.info "There seem to be #{missing_beaches} new beaches"
      Rails.logger.info "We updated #{count_updates} beaches"
    end

    def import_beaches_apa
      data = self.class.get('/perfil.json')&.body
      count = 0
      JSON.parse(data)['features'].each do |item|
        beach = item['attributes']
        store = Store.find_or_initialize_by(original_id: beach['id'], source: 'APA', store_type: :beach)
        next unless store.new_record?

        count += 1
        store.country = 'Portugal'
        store.name = beach['praia']
        store.district = beach['arh'].titleize
        store.latitude = beach['latitude']
        store.longitude = beach['longitude']
        store.source = 'APA'
        store.original_id = beach['id']

        store.beach_configuration&.delete

        store.beach_configuration = BeachConfiguration.new(
          code: beach['code']&.to_s,
          water_code: beach['codigo_agua_balnear'],
          guarded: beach['vigilancia'],
          first_aid_station: beach['posto_socorros'],
          wc: beach['sanitarios'],
          showers: beach['duche'],
          garbage_collection: beach['recolha_lixo'],
          cleaning: beach['limpeza_praia'],
          info_panel: beach['painel_informativo'],
          bathing_support: beach['apoio_balnear'],
          beach_support: beach['apoio_praia'],
          parking: beach['estacionamento'],
          quality_flag: beach['bandeira_azul'],
          accessibility: beach['acessivel'],
          water_chair: beach['cadeira_anfibia'],
          construction: beach['obras_em_curso'],
          collapsing_risk: beach['risco_derrocada'],
          season_start: Date.parse("06/06/#{Date.current.year}"),
          season_end: Date.parse("30/09/#{Date.current.year}")
        )
        store.save
      end
    end

    def import_beaches_deco
      import 'Importing beaches', 'praias.csv' do |file|
        CSV.new(file, headers: true, skip_blanks: true).each do |csv|
          store = Store.new(
            name: csv[1]&.strip,
            country: 'Portugal',
            store_type: :beach,
            city: csv[4]&.strip,
            street: csv[5]&.strip,
            district: "#{csv[3]}, #{csv[2]}",
            latitude: csv[6],
            longitude: csv[7],
            source: 'DECO Proteste'
          )
          season_dates = csv[25].split(' a ')
          season_dates = nil unless season_dates.size == 2
          store.beach_configuration = BeachConfiguration.new(
            category: csv[8].strip == 'Fluvial' ? :river : :ocean,
            beach_type: csv[9]&.strip,
            ground: csv[10]&.strip,
            restrictions: csv[11]&.strip,
            risk_areas: csv[12]&.strip,
            average_users: csv[13]&.strip,
            guarded: csv[14],
            first_aid_station: csv[15],
            wc: csv[16],
            showers: csv[17],
            accessibility: csv[18],
            garbage_collection: csv[19],
            cleaning: csv[20],
            info_panel: csv[21],
            restaurant: csv[22],
            parking: csv[23],
            parking_spots: csv[24],
            season_start: season_dates ? Date.parse(season_dates.first) : Date.parse("06/06/#{Date.current.year}"),
            season_end: season_dates ? Date.parse(season_dates.last) : Date.parse("30/09/#{Date.current.year}"),
            water_quality: csv[31],
            water_quality_url: csv[32]&.strip,
            quality_flag: csv[33],
            water_quality_entity: csv[35]&.strip,
            water_quality_contact: csv[36]&.strip,
            water_contact_email: csv[37]&.strip,
            security_entity: csv[38]&.strip,
            security_entity_contact: csv[39]&.strip,
            security_entity_email: csv[40]&.strip,
            health_authority: csv[41]&.strip,
            health_authority_contact: csv[42]&.strip,
            health_authority_email: csv[43]&.strip,
            municipality: csv[44]&.strip,
            municipality_contact: csv[45]&.strip,
            municipality_email: csv[46]&.strip
          )

          store.save
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
