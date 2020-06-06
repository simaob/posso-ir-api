class ApaFetcher
  include Singleton
  include HTTParty

  base_uri 'infopraiaapi.apambiente.pt'

  class << self
    delegate :water_quality, to: :instance
    delegate :occupation, to: :instance
    delegate :city_and_water_classification, to: :instance
  end

  def city_and_water_classification
    data = self.class.get('/qualidade.json')&.body
    return if data.blank?

    JSON.parse(data)['features'].each do |entry|
      attrs = entry['attributes']
      next unless attrs['codigo_agua_balnear']

      b_config = BeachConfiguration.find_by(water_code: attrs['codigo_agua_balnear'])

      unless b_config
        Rails.logger.info "can't find beach config for #{attrs['codigo_agua_balnear']}"
        next
      end

      beach = b_config.store
      beach.city = attrs['concelho']&.titleize
      beach.save

      b_config.water_classification = attrs['categoria_agua_balnear']
      b_config.save
    end
  end

  def water_quality
    data = self.class.get('/qualidade.json')&.body
    return if data.blank?

    JSON.parse(data)['features'].each do |entry|
      attrs = entry['attributes']
      next if !attrs['data_ultima_classificacao'] || !attrs['codigo_agua_balnear']

      b_config = BeachConfiguration.find_by(water_code: attrs['codigo_agua_balnear'])

      unless b_config
        Rails.logger.info "can't find beach config for #{attrs['codigo_agua_balnear']}"
        next
      end

      last_update = DateTime.strptime(attrs['data_ultima_classificacao'].to_s, '%Q')
      next if b_config.water_quality_updated_at.present? && b_config.water_quality_updated_at > last_update

      b_config.water_quality = attrs['ultima_classificacao']
      b_config.water_quality_updated_at = last_update
      b_config.save
    end
  end

  def occupation
    data = self.class.get('/ocupacao.json')&.body
    return if data.blank?

    JSON.parse(data).each do |entry|
      b_config = BeachConfiguration.find_by(code: entry['code'])
      next unless b_config && entry['state'].present? && entry['hour'].present?

      time = DateTime.strptime(entry['hour'].to_s, '%Q')

      state = case entry['state']
              when '1'
                0.0
              when '2'
                5.0
              else
                10.0
              end

      # avoid duplications
      next if StatusStoreOwner.where(store_id: b_config.store.id,
                                     updated_time: time,
                                     status: state,
                                     is_official: true).any?

      StatusStoreOwner.create!(
        store_id: b_config.store.id,
        updated_time: time,
        status: state,
        valid_until: time + 2.hours,
        is_official: true
      )
    end
  end
end
