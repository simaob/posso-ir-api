# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default("")
#  encrypted_password     :string           default("")
#  name                   :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  app_uuid               :string
#  last_post              :datetime
#  role                   :integer          default("0")
#  store_owner_code       :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  phone                  :string
#
FactoryBot.define do
  factory :user do
    factory :admin_user, class: 'User' do
      role { 'admin' }
      password { 'testpassword' }
      sequence(:email) { |n| "#{n}@test.com" }
    end
    after(:create) do |user, _evaluator|
      user.regenerate_api_key
    end
  end
end
