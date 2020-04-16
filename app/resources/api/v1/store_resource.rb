module Api
  module V1
    class StoreResource < ApplicationResource
      immutable
      caching

      attributes :name, :group, :address, :coordinates, :capacity,
                 :details, :store_type, :lonlat

      filters :location, :store_type

      filter :location, apply: ->(_records, value, options) {
        current_user = options[:context][:current_user]
        if current_user&.store_owner?
          current_user.stores.retrieve_stores(value.first, value.second)
        else
          Store.retrieve_stores(value.first, value.second)
        end
      }

      def address
        @model.address(unique: true)
      end

      def coordinates
        [@model.latitude, @model.longitude]
      end

      def self.records(options = {})
        current_user = options[:context][:current_user]
        if current_user&.store_owner?
          current_user.stores.available
        else
          Store.available
        end
      end
    end
  end
end
