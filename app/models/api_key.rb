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
class ApiKey < ApplicationRecord
  belongs_to :user, optional: false

  validates_presence_of :access_token
  validates_presence_of :expires_at
  validates_uniqueness_of :access_token
  validate :one_active_per_user

  before_validation :set_expires_at
  before_validation :set_access_token

  private

  def one_active_per_user
    return unless active?

    active_keys = ApiKey.where(user_id: user_id, active: true).count
    max_active = persisted? ? 1 : 0
    return if active_keys <= max_active

    errors.add(:active, 'Only one active key allowed per user')
  end

  def set_expires_at
    self.expires_at = Time.now + 3.months
  end

  def set_access_token
    self.access_token =
      JwtService.encode payload: {user_id: user_id, created_at: Time.now}
  end
end
