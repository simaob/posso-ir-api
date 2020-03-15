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
