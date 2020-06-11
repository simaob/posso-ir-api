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

class BeachSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash
  set_type :beaches

  attributes :original_id

  attribute :status do |object|
    # TODO: Change the stores to have only one status crowdsource
    case object.status_crowdsources.first&.status
    when 0...3.4
      1
    when 3.4...6.7
      2
    when 6.7...10
      3
    end
  end

  # cache_options enabled: true, cache_length: 2.hours
end
