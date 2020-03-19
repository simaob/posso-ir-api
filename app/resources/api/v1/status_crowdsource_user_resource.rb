module Api
  module V1
    class StatusCrowdsourceUserResource < ApplicationResource
      #immutable
      #caching
      #
      #attributes :name, :group, :address, :coordinates, :capacity,
      #           :details, :store_type, :lonlat
      #
      #filters :location
      #
      #filter :location, apply: ->(records, value, _options) {
      #  #records.by_category(value)
      #  Store.retrieve_stores(value.first, value.second)
      #}
      #
      #def coordinates
      #  [@model.latitude, @model.longitude]
      #end
    end
  end
end
