# == Schema Information
#
# Table name: user_stores
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  store_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserStore < ApplicationRecord
  belongs_to :manager, class_name: 'User', foreign_key: :user_id, inverse_of: :user_stores
  belongs_to :store, inverse_of: :user_stores

  def self.search(search)
    return all unless search

    joins(:store)
      .where('stores.name ilike ? OR stores.street ilike ? OR stores.district ilike ? OR stores.city ilike ?',
          "%#{search}%", "%#{search}%",
          "%#{search}%", "%#{search}%")
  end
end
