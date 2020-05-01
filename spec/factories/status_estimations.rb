FactoryBot.define do
  factory :status_estimation do
    association :store
    status { 5 }
  end
end
