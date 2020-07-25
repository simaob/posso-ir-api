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
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#
class UserSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash
  set_type :user

  attribute :email
  attribute :name
  attribute :sign_in_count
  attribute :reports_made do |object|
    Rails.env.production? ? object.status_crowdsource_users.count : rand(1..100)
  end
  attribute :reporter_ranking do |object|
    Rails.env.production? ? object.reporter_rank : rand(1..120)
  end
  attribute :reporter_places do |object|
    Rails.env.production? ? object.reporter_places : rand(1..100)
  end
  attribute :reporter_reports do |object|
    Rails.env.production? ? object.reporter_reports : rand(1..100)
  end
  attribute :reporter_score do |object|
    Rails.env.production? ? object.reporter_score : rand(1..100)
  end
  attribute :winner_count do
    Rails.env.production? ? 0 : rand(0..3)
  end
  attribute :top_10_count do
    Rails.env.production? ? 0 : rand(0..3)
  end
  attribute :top_50_count do
    Rails.env.production? ? 0 : rand(0..3)
  end
  attribute :top_100_count do
    Rails.env.production? ? 0 : rand(0..3)
  end

  has_many :stores, type: :stores, serializer: StoreSerializer

  Badge.order(:slug).each do |badge|
    attribute "badge_#{badge.slug}".to_sym do |object|
      UserBadge.find_by(user_id: object.id, badge_id: badge.id).present?
    end
  end
end
