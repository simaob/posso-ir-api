FactoryBot.define do
  factory :status_crowdsource do
    association :store
    updated_time { Time.now }
  end
end
