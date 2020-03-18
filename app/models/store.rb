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
  # geocoded_by :address
  # reverse_geocoded_by :latitude, :longitude

  enum store_type: { 1 => 'Supermarket', 2 => 'Pharmacy' }

  validates :capacity, allow_nil: true, numericality: { greater_than: 0 }

  # after_validation :reverse_geocode
  # after_validation :geocode
  before_save :set_lonlat

  private

  def address
    [street, city].compact.join(',')
  end

  # x: longitude
  # y: latitude
  def set_lonlat
    return unless latitude && longitude

    self.lonlat = Store.select("ST_MakePoint(#{longitude}, #{latitude}) AS point")
      .limit(1).first&.point
  end
end
