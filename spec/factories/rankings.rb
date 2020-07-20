# == Schema Information
#
# Table name: rankings
#
#  id         :bigint           not null, primary key
#  position   :integer          not null
#  score      :integer          not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reports    :integer          default("0"), not null
#  places     :integer          default("0"), not null
#
FactoryBot.define do
  factory :ranking do
    position { 1 }
    score { 1 }
    user_id { nil }
  end
end
