class StatusCrowdsourceUser < ApplicationRecord
  belongs_to :user
  belongs_to :status_crowdsource
end