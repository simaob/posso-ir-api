# == Schema Information
#
# Table name: api_keys
#
#  id           :bigint           not null, primary key
#  access_token :string           not null
#  expires_at   :datetime         not null
#  active       :boolean          default("false")
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint
#
FactoryBot.define do
  factory :api_key do
  end
end
