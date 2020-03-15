class StatusUserCommitmentUser < ApplicationRecord
  belongs_to :user
  belongs_to :status_user_commitment
end