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
#

class StoreSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash
  set_type :stores
  has_one :beach_configuration, if: proc { |s| s.beach? }

  attributes :name, :group, :address, :capacity,
             :details, :store_type, :lonlat, :opening_hour, :closing_hour

  attribute :photo do |object|
    rails_blob_path(object.photo, only_path: true) if object.photo.attached?
  end

  attribute :closing_hour do |object|
    object.current_day&.closing_hour
  end
  attribute :opening_hour do |object|
    object.current_day&.opening_hour
  end
  attribute :coordinates do |object|
    [object.latitude, object.longitude]
  end
  attribute :category, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.category
  end
  attribute :quality_flag, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.quality_flag
  end
  attribute :average_users, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.average_users
  end
  attribute :guarded, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.guarded
  end
  attribute :first_aid_station, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.first_aid_station
  end
  attribute :wc, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.wc
  end
  attribute :showers, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.showers
  end
  attribute :accessibility, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.accessibility
  end
  attribute :parking, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.parking
  end
  attribute :parking_spots, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.parking_spots
  end
  attribute :season_start, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.season_start
  end
  attribute :season_end, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.season_end
  end
  attribute :water_quality, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_quality
  end
  attribute :water_quality_last_updated_at, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_quality_last_updated_at
  end
  attribute :water_quality_url, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_quality_url
  end
  attribute :quality_flag, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.quality_flag
  end

  # cache_options enabled: true, cache_length: 2.hours
end
