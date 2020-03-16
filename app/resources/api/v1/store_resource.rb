module Api
  module V1
    class StoreResource < ApplicationResource
      immutable
      attributes :name, :group, :address, :coordinates, :capacity, :details, :store_type
    end
  end
end