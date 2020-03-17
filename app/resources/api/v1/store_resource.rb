module Api
  module V1
    class StoreResource < ApplicationResource
      immutable
      attributes :name, :group, :address, :coordinates, :capacity, :details, :store_type

      def coordinates
        [@model.latitude, @model.longitude]
      end
    end
  end
end
