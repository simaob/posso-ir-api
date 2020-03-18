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
FactoryBot.define do
  factory :store do
    name { "MyString" }
    group { "MyString" }
    street { "MyString" }
    city { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
    capacity { 1 }
    details { "MyText" }
  end
end
