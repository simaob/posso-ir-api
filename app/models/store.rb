# == Schema Information
#
# Table name: stores
#
#  id         :bigint           not null, primary key
#  name       :string
#  group      :string
#  street     :string
#  city       :string
#  district   :string
#  country    :string
#  zip_code   :string
#  latitude   :float
#  longitude  :float
#  capacity   :integer
#  details    :text
#  store_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lonlat     :geometry         point, 0
#
class Store < ApplicationRecord
  RADIUS = 5
  PROJECTION = 4326

  # geocoded_by :address
  # reverse_geocoded_by :latitude, :longitude

  enum store_type: { 'Supermarket': 1, 'Pharmacy': 2 }

  validates :capacity, allow_nil: true, numericality: { greater_than: 0 }

  # after_validation :reverse_geocode
  # after_validation :geocode
  before_save :set_lonlat, if: -> { latitude_changed? || longitude_changed? }

  private

  def address
    [street, city].compact.join(',')
  end

  def self.retrieve_stores(lat, lon)
    query=
<<~SQL
 SELECT *
  FROM stores
  WHERE ST_CONTAINS(
    ST_BUFFER(
      ST_SetSRID(
          ST_MakePoint(#{lon}, #{lat}), 4326)::geography,
      #{RADIUS})::geometry,
    lonlat)
)))
SQL
    ActiveRecord::Base.connection.execute(query)
  end
    
  # x: longitude
  # y: latitude
  def set_lonlat
    self.lonlat = Store.select("ST_MakePoint(#{longitude}, #{latitude}) AS point")
      .limit(1).first&.point
  end
end
