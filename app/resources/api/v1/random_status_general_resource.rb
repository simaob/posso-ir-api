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
    class RandomStatusGeneralResource < ApplicationResource
      model_name 'StatusGeneral'
      immutable

      MAX_STORES = 300

      attributes :updated_time, :valid_until, :status,
                 :queue, :store_id, :is_official

      filter :store_id

      def updated_time
        Time.current - rand(1..65).minutes
      end

      def status
        rand(-1..10)
      end

      def queue
        @model.queue.nil? ? -1 : @model.queue
      end

      # rubocop:disable Naming/PredicateName
      def is_official
        [true, false].sample
      end
      # rubocop:enable Naming/PredicateName

      filter :store_id, apply: ->(records, value, _options) {
        value = value[0...MAX_STORES]
        records.where(store_id: value)
      }

      def self.records(_options = {})
        StatusGeneral.all
      end
    end
  end
end
