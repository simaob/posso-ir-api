class BeachConfigurationSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :store

  attributes :category, :beach_type, :ground, :restrictions, :risk_areas, :average_users,
             :guarded, :first_aid_station, :wc, :showers, :accessibility, :garbage_collection, :cleaning, :info_panel,
             :restaurant, :parking, :parking_spots, :season_start, :season_end, :water_quality, :water_quality_url,
             :quality_flag, :water_quality_entity, :water_quality_contact, :water_contact_email, :security_entity,
             :security_entity_contact, :security_entity_email, :health_authority, :health_authority_contact,
             :health_authority_email, :municipality, :municipality_contact, :municipality_email
  cache_options enabled: true, cache_length: 2.hours
end
