class UserStore < ApplicationRecord
  belongs_to :manager, class_name: 'User', foreign_key: :user_id, inverse_of: :user_stores
  belongs_to :store, inverse_of: :user_stores
end
