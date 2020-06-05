# == Schema Information
#
# Table name: beach_configurations
#
#  id                       :bigint           not null, primary key
#  category                 :integer
#  beach_type               :string
#  ground                   :string
#  restrictions             :string
#  risk_areas               :string
#  average_users            :integer
#  guarded                  :boolean
#  first_aid_station        :boolean
#  wc                       :boolean
#  showers                  :boolean
#  accessibility            :boolean
#  garbage_collection       :boolean
#  cleaning                 :boolean
#  info_panel               :boolean
#  restaurant               :boolean
#  parking                  :boolean
#  parking_spots            :integer
#  season_start             :date
#  season_end               :date
#  water_quality            :integer
#  water_quality_url        :string
#  quality_flag             :boolean
#  water_quality_entity     :string
#  water_quality_contact    :string
#  water_contact_email      :string
#  security_entity          :string
#  security_entity_contact  :string
#  security_entity_email    :string
#  health_authority         :string
#  health_authority_contact :string
#  health_authority_email   :string
#  municipality             :string
#  municipality_contact     :string
#  municipality_email       :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  store_id                 :bigint
#  beach_support            :boolean
#  water_chair              :boolean
#  construction             :boolean
#  collapsing_risk          :boolean
#  code                     :string
#  water_code               :string
#  bathing_support          :boolean
#  water_quality_updated_at :datetime
#  water_classification     :integer
#
class BeachConfigurationSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :store

  attributes :category,
             :beach_type,
             :average_users,
             :guarded,
             :first_aid_station,
             :wc,
             :showers,
             :accessibility,
             :parking,
             :parking_spots,
             :season_start,
             :season_end,
             :water_quality,
             :water_quality_url,
             :quality_flag
  #             :restaurant,
  #             :garbage_collection,
  #             :cleaning,
  #             :info_panel,
  #             :ground,
  #             :restrictions,
  #             :risk_areas,
  #             :water_quality_entity,
  #             :water_quality_contact,
  #             :water_contact_email,
  #             :security_entity,
  #             :security_entity_contact,
  #             :security_entity_email,
  #             :health_authority,
  #             :health_authority_contact,
  #             :health_authority_email,
  #             :municipality,
  #             :municipality_contact,
  #             :municipality_email,
  #             :beach_support,
  #             :water_chair,
  #             :construction,
  #             :collapsing_risk

  cache_options enabled: true, cache_length: 2.hours
end
