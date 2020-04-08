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
    class StatusGeneralResource < StatusResource
      attributes :is_official

      def is_official
        if Rails.env.production?
          @model.is_official
        else
          [true, false].shuffle.first
        end
      end
    end
  end
end
