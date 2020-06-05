class RandomStoreSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash
  set_type :stores

  attributes :name, :group, :address, :capacity,
             :details, :store_type, :lonlat, :opening_hour, :closing_hour

  attribute :photo do |object|
    rails_blob_path(object.photo, only_path: true) if object.photo.attached?
  end

  attribute :closing_hour do
    Time.zone.parse(['18:00', '19:00', '22:00', '23:59'].sample)
  end
  attribute :opening_hour do
    Time.zone.parse(['8:00', '9:00', '10:00', '11:00'].sample)
  end
  attribute :coordinates do |object|
    [object.latitude, object.longitude]
  end
  attribute :category, if: proc { |object| object.beach? } do
    [:ocean, :river].sample
  end
  attribute :quality_flag, if: proc { |object| object.beach? } do
    [true, false].sample
  end
  attribute :average_users, if: proc { |object| object.beach? } do
    rand(10..200)
  end
  attribute :guarded, if: proc { |object| object.beach? } do
    [true, false].sample
  end
  attribute :first_aid_station, if: proc { |object| object.beach? } do
    [true, false].sample
  end
  attribute :wc, if: proc { |object| object.beach? } do
    [true, false].sample
  end
  attribute :showers, if: proc { |object| object.beach? } do
    [true, false].sample
  end
  attribute :accessibility, if: proc { |object| object.beach? } do
    [true, false].sample
  end
  attribute :parking, if: proc { |object| object.beach? } do
    [true, false].sample
  end
  attribute :parking_spots, if: proc { |object| object.beach? } do
    rand(10..80)
  end
  attribute :season_start, if: proc { |object| object.beach? } do
    Date.parse('06/06/2020')
  end
  attribute :season_end, if: proc { |object| object.beach? } do
    Date.parse('30/09/2020')
  end
  attribute :water_classification, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_classification.presence || rand(1..4)
  end
  attribute :water_quality, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_quality.presence || rand(1..4)
  end
  attribute :water_quality_updated_at, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_quality_updated_at.presence || (Time.current - 2.hours)
  end
  attribute :water_quality_url, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.water_quality_url.presence || 'https://apambiente.pt/'
  end
  attribute :quality_flag, if: proc { |object| object.beach? } do |object|
    object.beach_configuration.quality_flag.presence || [true, false].sample
  end

  def address
    ['Passeio Alegre, Porto', 'Rua da Praia', 'Junto à Areia, Porto, Portugal'].sample
  end
end
