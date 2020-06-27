# == Schema Information
#
# Table name: beach_configurations
#
#  id                       :bigint           not null, primary key
#  guarded                  :boolean
#  first_aid_station        :boolean
#  wc                       :boolean
#  showers                  :boolean
#  accessibility            :boolean
#  garbage_collection       :boolean
#  cleaning                 :boolean
#  info_panel               :boolean
#  parking                  :boolean
#  season_start             :date
#  season_end               :date
#  water_quality            :integer
#  water_quality_url        :string
#  quality_flag             :boolean
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
#  sapo_code                :string
#
class BeachConfiguration < ApplicationRecord
  belongs_to :store
  scope :by_state, ->(state) { where(state: state) }
end
