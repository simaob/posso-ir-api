module Api
  module V1
    class StatusCrowdsourceUserResource < ApplicationResource
      include UserPostable

      attributes :status, :queue, :posted_at, :store_id,
                 :user_id, :badges_won

      before_create :set_user_id, :validate_user_interval
      after_create :update_user_time

      def badges_won
        Rails.env.production? ? [] : Badge.pluck(:slug).sample(rand(0..2))
      end

      def set_user_id
        return if context[:current_user].blank?

        @model.user_id = context[:current_user].id
      end
    end
  end
end
