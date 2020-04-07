
FactoryBot.define do
  factory :status_crowdsource_user do
    status { 5 }
    posted_at { Time.now }
    association :user
    association:store
  end
end
