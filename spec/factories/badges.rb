# == Schema Information
#
# Table name: badges
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  badge_type :integer          default("1"), not null
#  store_type :integer
#  target     :integer          default("0"), not null
#  counter    :string
#
FactoryBot.define do
  factory :badge_daily_login_count, class: 'Badge' do
    name { 'Welcome' }
    slug { 'welcome' }
    target { 1 }
    counter { 'daily_login_count' }
  end
  factory :badge_total_reports, class: 'Badge' do
    name { 'Noob' }
    slug { 'noob' }
    target { 1 }
    counter { 'total_reports' }
  end
  factory :badge_total_2, class: 'Badge' do
    name { 'Traveler' }
    slug { 'traveler' }
    target { 2 }
    counter { 'total_unique' }
  end
  factory :badge_beach_unique_2, class: 'Badge' do
    name { 'Beach' }
    slug { 'beach' }
    target { 2 }
    counter { 'beach_unique' }
  end
end
