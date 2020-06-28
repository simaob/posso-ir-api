# == Schema Information
#
# Table name: favorites
#
#  id         :bigint           not null, primary key
#  store_id   :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Favorite < ApplicationRecord
  belongs_to :store
  belongs_to :user

  validates :store_id, uniqueness: {scope: :user_id}
end
