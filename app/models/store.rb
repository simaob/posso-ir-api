class Store < ApplicationRecord
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude

  validates :capacity, allow_nil: true, numericality: { greater_than: 0 }

  after_validation :reverse_geocode
  after_validation :geocode

  def address
    [street, city].join(',')
  end
end
