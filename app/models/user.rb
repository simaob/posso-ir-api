# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default("")
#  encrypted_password     :string           default("")
#  name                   :string
#  admin                  :boolean
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  app_uuid               :string
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable

  with_options if: :admin? do |admin|
    admin.validates_presence_of :email
    admin.validates_presence_of :password, if: :password_required?
    admin.validates_confirmation_of :password, if: :password_required?
    admin.validates_length_of :password, within: 6..128, allow_blank: true
  end
  validates_uniqueness_of :email

  protected

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere.
  def password_required?
    admin? && (!persisted? || !password.nil? || !password_confirmation.nil?)
  end
end
