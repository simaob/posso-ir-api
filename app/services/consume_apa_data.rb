class ConsumeApaData
  include Singleton
  include HTTParty

  base_uri 'infopraiaapi.apambiente.pt'

  class << self
    delegate :water_quality, to: :instance
    delegate :occupation, to: :instance
  end

  def water_quality
    data = self.class.get('/qualidade.json')&.body
    return unless data.present?

    JSON.parse(data)['features'].each do |entry|
      attrs = entry['attributes']
      next if !attrs['data_ultima_classificacao'] || !entry['codigo_agua_balnear']

      b_config = BeachConfiguration.find_by(water_code: entry['codigo_agua_balnear'])
      last_update = DateTime.strptime(attrs['data_ultima_classificacao'].to_s, '%Q')

      if !b_config.water_quality_last_updated_at || b_config.water_quality_last_updated_at < last_update
        b_config.water_quality = attrs['ultima_classificacao']
        b_config.water_quality_last_updated_at = last_update
        b_config.save
        puts "Updated #{b_config.store.name}"
      end
    end
  end
end
