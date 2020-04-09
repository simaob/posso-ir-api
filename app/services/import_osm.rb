class ImportOsm
  def import(country)
    import_to_stores(country)
  end

  def import_to_stores(country)
    OsmPoint.find_each do |point|
      create_store(point, country)
    end
    OsmPoint.delete_all
  end

  def create_store(point, country)
    store_type = if point[:amenity]
                   map_amenity(point[:amenity])
                 elsif point[:shop]
                   map_shop(point[:shop])
                 end

    return unless %w[supermarket pharmacy restaurant gas_station bank 
                       coffee kiosk other atm post_office].include? store_type
    address = "#{point[:street]} #{point[:housenumber]} #{point[:housename]}"
    group = point[:operator] || point[:brand]

    Store.create!(
          name: point[:name],
          group: group,
          street: address,
          city: point[:city],
          district: point[:district],
          country: country,
          zip_code: point[:zip_code],
          latitude: point[:latitude],
          longitude: point[:longitude],
          store_type: store_type,
          lonlat: point[:geom],
          from_osm: true 
    )
  end

  def map_amenity(type)
    if %w[restaurant fastfood pub bbq food_court].include?(type)
      "restaurant"
    elsif type == "fuel"
      "gas_station"
    elsif %w[cafe bakery ice_cream internet_cafe].include?(type)
      "coffee"
    elsif %w[marketplace community_centre post_depot veterinary hospital clinic
             car_wash car_rental bus_station].include?(type)
      "other"
    else
      type
    end
  end

  def map_shop(type)
    if %w[supermarket convenience deli frozen_food green_grocer wholesale].include?(type)
      "supermarket"
    elsif %w[pharmacy chemist].include?(type)
      "pharmacy"
    else
      "other"
    end
  end
end