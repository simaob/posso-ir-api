module Api
  module V1
    class StatusCrowdsourceUserResource < ApplicationResource
      include UserPostable

      attributes :status, :queue, :posted_at, :store_id,
                 :user_id

      before_create :set_user_id, :validate_user_interval
      after_create :update_user_time

      def set_user_id
        return unless context[:current_user].present?

        @model.user_id = context[:current_user].id
      end
    end
  end
end
