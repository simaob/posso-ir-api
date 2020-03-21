# == Schema Information
#
# Table name: statuses
#
#  id           :bigint           not null, primary key
#  updated_time :datetime         not null
#  valid_until  :datetime
#  status       :integer
#  queue        :integer
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  store_id     :bigint
#
module Api
  module V1
    class StatusCrowdsourceResource < ApplicationResource
      immutable

      attributes :id, :updated_time, :valid_until, :status,
                 :queue, :store_id

      filter :store_id

      def status
        @model.status.nil? ? -1 : @model.status
      end

      def queue
        @model.queue.nil? ? -1 : @model.queue
      end
    end
  end
end
