FactoryBot.define do
  factory :week_day do
    association :store
    opening_hour { Time.zone.parse('8:00') }
    closing_hour { Time.zone.parse('23:00') }
    day { Date.current.wday }
  end
end
