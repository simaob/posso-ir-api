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
#
class Store < ApplicationRecord
  RADIUS = 5
  PROJECTION = 4326

  # geocoded_by :address
  # reverse_geocoded_by :latitude, :longitude

  enum store_type: { 1 => 'Supermarket', 2 => 'Pharmacy' }

  validates :capacity, allow_nil: true, numericality: { greater_than: 0 }

  # after_validation :reverse_geocode
  # after_validation :geocode

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
end
