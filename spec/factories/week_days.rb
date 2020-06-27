# == Schema Information
#
# Table name: week_days
#
#  id             :bigint           not null, primary key
#  day            :integer          not null
#  opening_hour   :time
#  closing_hour   :time
#  active         :boolean          default("false")
#  timestamps     :string
#  store_id       :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  open           :boolean          default("true")
#  opening_hour_2 :time
#  closing_hour_2 :time
#
FactoryBot.define do
  factory :week_day do
    association :store
    opening_hour { Time.zone.parse('8:00') }
    closing_hour { Time.zone.parse('23:00') }
    day { Date.current.wday }
  end
end
