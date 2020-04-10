# == Schema Information
#
# Table name: stores
#
#  id               :bigint           not null, primary key
#  name             :string
#  group            :string
#  street           :string
#  city             :string
#  district         :string
#  country          :string
#  zip_code         :string
#  latitude         :float
#  longitude        :float
#  capacity         :integer
#  details          :text
#  store_type       :integer          default("1"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  lonlat           :geometry         point, 0
#  state            :integer          default("1")
#  reason_to_delete :text
#  open             :boolean          default("true")
#  created_by_id    :bigint
#  updated_by_id    :bigint
#  from_osm         :boolean          default("false")
#  original_id      :bigint
#
class Store < ApplicationRecord
  include UserTrackable

  RADIUS = 5000
  PROJECTION = 4326

  has_many :status_crowdsources
  has_many :status_store_owners
  has_many :status_generals
  has_many :statuses
  has_many :status_crowdsource_users

  has_many :user_stores, inverse_of: :store
  has_many :managers, through: :user_stores

  # geocoded_by :address
  # reverse_geocoded_by :latitude, :longitude

  enum store_type: {supermarket: 1, pharmacy: 2, restaurant: 3,
                    gas_station: 4, bank: 5, coffee: 6, kiosk: 7,
                    other: 8, atm: 9, post_office: 10}
  enum state: {waiting_approval: 1, live: 2, marked_for_deletion: 3}

  validates :capacity, allow_nil: true, numericality: {greater_than: 0}

  scope :by_group, ->(group) { where(group: group) }
  scope :by_state, ->(state) { where(state: state) }
  scope :by_store_type, ->(store_type) { where(store_type: store_type) }
  scope :available, -> { where(state: [:live, :marked_for_deletion]).where(open: true) }

  # after_validation :reverse_geocode
  # after_validation :geocode
  after_save :set_lonlat
  after_create :create_status

  def address(unique: false)
    result = [street, city, country].map(&:presence).compact
    result << "store-#{id}" if unique
    result.join(', ')
  end

  def text
    [name, city].compact.join(', ')
  end

  def self.groups
    select(:group).order(:group).distinct.pluck(:group)
  end

  def latest_owner_status
    status_store_owners.order(updated_at: :desc).limit(1)&.first
  end

  def self.search(search)
    return all unless search

    where('name ilike ? OR street ilike ? OR district ilike ? OR city ilike ?',
          "%#{search}%", "%#{search}%",
          "%#{search}%", "%#{search}%")
  end

  def self.retrieve_stores(lat, lon)
    query = <<~SQL
      ST_CONTAINS(
        ST_BUFFER(
          ST_SetSRID(
            ST_MakePoint(#{lon}, #{lat}), 4326)::geography,
              #{RADIUS})::geometry, lonlat)
    SQL

    Store.where(query).available
  end

  private

  # x: longitude
  # y: latitude
  def set_lonlat
    return unless persisted? && latitude.present? && longitude.present?

    sql = <<~SQL
      UPDATE stores
      SET lonlat = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
      WHERE id = #{id}
    SQL
    ActiveRecord::Base.connection.execute sql
  end

  def create_status
    create_crowdsource_status
    create_store_owner_status
    create_general_status
  end

  def create_crowdsource_status
    status = StatusCrowdsourceUser.where(store_id: id).first
    return if status

    StatusCrowdsource.create(store_id: id, updated_time: Time.now)
  end

  def create_store_owner_status
    status = StatusStoreOwner.new(store_id: id,
                                  updated_time: Time.now, active: true)
    status.save!(validate: false)
  end

  def create_general_status
    StatusGeneral.create!(store_id: id, updated_time: Time.now, is_official: false)
  end
end
