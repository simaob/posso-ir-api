module Importer
  class ImportOsm
    def import(country)
      Dir.glob(Rails.root.join('db', 'files', "#{country}*")) do |filename|
        file = File.open(filename, 'r')
        CSV.new(file, skip_blanks: true).each { |point| create_store(point, country) }
      end
    end

    def create_store(point, country)
      store_type = if point[7]
                     map_amenity(point[7])
                   elsif point[8]
                     map_shop(point[8])
                   end

      return unless %w[supermarket pharmacy restaurant gas_station bank
                       coffee kiosk other atm post_office].include? store_type

      address = "#{point[10]} #{point[2]} #{point[1]}".squish
      group = point[9] || point[4]

      Store.create!(
        original_id: point[0],
        name: point[3],
        group: group,
        street: address,
        city: point[11],
        district: point[13],
        country: country,
        zip_code: point[14],
        latitude: point[17],
        longitude: point[18],
        store_type: store_type,
        lonlat: point[19],
        source: 'OSM',
        state: :waiting_approval
      )
    end

    def map_amenity(type)
      if %w[restaurant fastfood pub bbq food_court].include?(type)
        'restaurant'
      elsif type == 'fuel'
        'gas_station'
      elsif %w[cafe bakery ice_cream internet_cafe].include?(type)
        'coffee'
      elsif %w[marketplace community_centre post_depot veterinary hospital clinic
               car_wash car_rental bus_station].include?(type)
        'other'
      else
        type
      end
    end

    def map_shop(type)
      if %w[supermarket convenience deli frozen_food green_grocer wholesale].include?(type)
        'supermarket'
      elsif %w[pharmacy chemist].include?(type)
        'pharmacy'
      else
        'other'
      end
    end
  end
end
