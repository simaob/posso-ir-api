module Api
  module V1
    class StatusStoreOwnerResource < ApplicationResource
      attributes :status, :queue, :store_id
      attribute :posted_at, delegate: :updated_time
    end
  end
end
