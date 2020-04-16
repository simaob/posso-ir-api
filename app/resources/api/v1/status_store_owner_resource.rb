module Api
  module V1
    class StatusStoreOwnerResource < ApplicationResource
      attributes :status, :queue, :updated_time, :store_id
    end
  end
end
