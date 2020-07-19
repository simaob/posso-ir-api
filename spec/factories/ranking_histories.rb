# == Schema Information
#
# Table name: ranking_histories
#
#  id         :bigint           not null, primary key
#  position   :integer          not null
#  score      :integer          not null
#  user_id    :integer          not null
#  date       :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :ranking_history do
    position { 1 }
    score { 1 }
    users { nil }
    date { '2020-07-19' }
  end
end
