module Api
  module V1
    class WeekDayResource < ApplicationResource
      immutable

      has_one :store_resource, exclude_links: :default

      attributes :opening_hour, :closing_hour, :day, :active

      exclude_links :default
    end
  end
end
