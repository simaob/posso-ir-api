# == Schema Information
#
# Table name: stores
#
#  id                  :bigint           not null, primary key
#  name                :string
#  group               :string
#  street              :string
#  city                :string
#  district            :string
#  country             :string
#  zip_code            :string
#  latitude            :float
#  longitude           :float
#  capacity            :integer
#  details             :text
#  store_type          :integer          default("1"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  lonlat              :geometry         point, 0
#  state               :integer          default("1")
#  reason_to_delete    :text
#  open                :boolean          default("true")
#  created_by_id       :bigint
#  updated_by_id       :bigint
#  from_osm            :boolean          default("false")
#  original_id         :bigint
#  source              :string
#  make_phone_calls    :boolean          default("false")
#  phone_call_interval :integer          default("60")
#  municipality        :string
#

class StoreSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash
  set_type :stores
  has_one :beach_configuration, if: proc { |s| s.beach? }

  attributes :name, :group, :address, :capacity,
             :details, :store_type, :lonlat, :opening_hour, :closing_hour

  attribute :closing_hour do |object|
    object.current_day&.closing_hour
  end
  attribute :opening_hour do |object|
    object.current_day&.opening_hour
  end
  attribute :closing_hour_2 do |object|
    object.current_day&.closing_hour_2
  end
  attribute :opening_hour_2 do |object|
    object.current_day&.opening_hour_2
  end
  attribute :open_today do |object|
    object.current_day&.open
  end
  attribute :coordinates do |object|
    [object.latitude, object.longitude]
  end
  attribute :quality_flag, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.quality_flag || false
  end
  attribute :guarded, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.guarded || false
  end
  attribute :first_aid_station, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.first_aid_station || false
  end
  attribute :wc, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.wc || false
  end
  attribute :showers, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.showers || false
  end
  attribute :parking, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.parking || false
  end
  attribute :water_classification, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_classification.presence || -1
  end
  attribute :water_quality_updated_at, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_quality_updated_at
  end
  attribute :average_users, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.average_users
  end
  attribute :water_quality_url, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_quality_url
  end
  attribute :accessibility, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.accessibility || false
  end
  attribute :water_quality, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_quality
  end
  attribute :photo do |object|
    rails_blob_path(object.photo, only_path: true) if object.photo.attached?
  end
  attribute :category, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.category
  end
  attribute :parking_spots, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.parking_spots
  end
  attribute :garbage_collection, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.garbage_collection || false
  end
  attribute :cleaning, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.cleaning || false
  end
  attribute :info_panel, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.info_panel || false
  end
  attribute :restaurant, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.restaurant || false
  end
  attribute :beach_support, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.beach_support || false
  end
  attribute :water_chair, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_chair || false
  end
  attribute :bathing_support, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.bathing_support || false
  end
  attribute :season_start, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.season_start
  end
  attribute :season_end, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.season_end
  end

  # cache_options enabled: true, cache_length: 2.hours
end
