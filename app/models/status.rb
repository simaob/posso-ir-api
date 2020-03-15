class Status < ApplicationRecord

  validates_presence_of :updated_time
  validates_presence_of :status


end