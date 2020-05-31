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
#  code                     :float
#  water_code               :string
#  bathing_support          :boolean
#  water_quality_updated_at :datetime
#
class BeachConfiguration < ApplicationRecord
  belongs_to :store

  enum category: {ocean: 1, river: 2}

  scope :by_state, ->(state) { where(state: state) }
end
