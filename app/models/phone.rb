# == Schema Information
#
# Table name: phones
#
#  id           :bigint           not null, primary key
#  phone_number :string           not null
#  name         :string
#  active       :boolean          default("true")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  store_id     :bigint
#
class Phone < ApplicationRecord
  belongs_to :store

  validates_presence_of :phone_number
  validates_uniqueness_of :phone_number
end
