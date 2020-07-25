module Api
  module V1
    class StatusCrowdsourceUserResource < ApplicationResource
      include UserPostable

      attributes :status, :queue, :posted_at, :store_id,
                 :user_id, :badges_won

      before_create :set_user_id, :validate_user_interval
      after_create :update_user_time, :increase_counters

      def badges_won
        if @model.user.badges_won.present?
          result = @model.user.badges_won.split(' ').compact.uniq
          @model.user.update(badges_won: '')
          result
        else
          []
        end
      end

      def set_user_id
        return if context[:current_user].blank?

        @model.user_id = context[:current_user].id
      end

      def increase_counters
        store_type = @model.store.store_type
        counters = ['total_reports']
        counters << "#{store_type}_reports" if %w(beach supermarket pharmacy restaurant).include?(store_type)

        @model.user.increase_badges_counter(*counters)
      end
    end
  end
end
