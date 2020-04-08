module Api
  module V1
    class StoreResource < ApplicationResource
      immutable
      caching

      attributes :name, :group, :address, :coordinates, :capacity,
                 :details, :store_type, :lonlat

      filters :location

      filter :location, apply: ->(_records, value, _options) {
        # records.by_category(value)
        Store.retrieve_stores(value.first, value.second)
      }

      def address
        @model.address(unique: true)
      end

      def coordinates
        [@model.latitude, @model.longitude]
      end

      def self.records(_options = {})
        Store.available
      end
    end
  end
end
