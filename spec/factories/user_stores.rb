# == Schema Information
#
# Table name: user_stores
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  store_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  approved   :boolean          default("false")
#
FactoryBot.define do
  factory :user_store do
    user { nil }
    store { nil }
  end
end
