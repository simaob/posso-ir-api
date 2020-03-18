module Api
  module V1
    class StoreResource < ApplicationResource
      immutable
      attributes :name, :group, :address, :coordinates, :capacity, :details,
        :store_type, :lonlat

      def coordinates
        [@model.latitude, @model.longitude]
      end
    end
  end
end
