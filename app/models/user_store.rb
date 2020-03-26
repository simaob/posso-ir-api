class UserStore < ApplicationRecord
  belongs_to :manager, class_name: 'User', foreign_key: :user_id
  belongs_to :store
end
