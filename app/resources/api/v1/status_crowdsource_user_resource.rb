module Api
  module V1
    class StatusCrowdsourceUserResource < ApplicationResource
      has_one :status_crowdsource
      attributes :status, :queue, :posted_at, :store_id,
                 :user_id



      before_create :set_user_id

      def set_user_id
        return unless context[:current_user].present?

        @model.user_id = context[:current_user].id
      end
    end
  end
end
