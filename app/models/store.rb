class Store < ApplicationRecord
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude

  enum store_type: { 1 => 'Supermarket', 2 => 'Pharmacy' }

  validates :capacity, allow_nil: true, numericality: { greater_than: 0 }

  after_validation :reverse_geocode
  after_validation :geocode

  def address
    [street, city].join(',')
  end
end
