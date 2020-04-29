# == Schema Information
#
# Table name: status_crowdsource_users
#
#  id         :bigint           not null, primary key
#  status     :integer          not null
#  queue      :integer
#  posted_at  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :bigint
#  user_id    :bigint
#
FactoryBot.define do
  factory :status_crowdsource_user do
    status { 5 }
    posted_at { Time.current }
    association :user
    association :store
  end
end
