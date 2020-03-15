class StatusUserCountUser < ApplicationRecord
  belongs_to :user
  belongs_to :status_user_count
end