# == Schema Information
#
# Table name: badges
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :badge do
    name { "MyString" }
    slug { "MyString" }
  end
end
