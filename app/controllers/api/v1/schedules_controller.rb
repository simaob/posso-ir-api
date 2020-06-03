module Api
  module V1
    class SchedulesController < ExternalApiController
      # This Endpoint is not using JSON API format!
      def create
        return forbidden unless current_user.admin?

        store = Store.find_by(id: params['store-id'])
        timetable = params['timetable']
        return wrong_store unless store
        return invalid_data if timetable.blank?

        timetable_errors = add_timetable(store, timetable)

        if timetable_errors.any?
          render json: {error: timetable_errors}, status: :unprocessable_entity
        else
          render json: {message: "Added schedule for store: #{store.id}"}, status: :created
        end
      end

      private

      def add_timetable(store, timetable)
        errors = []
        WeekDay.transaction do
          WeekDay.days.keys.each do |day|
            day_time = WeekDay.find_or_initialize_by(store_id: store.id, day: day)
            day_time.opening_hour = timetable.dig(day, 'o')
            day_time.closing_hour = timetable.dig(day, 'c')
            day_time.save!
          rescue StandardError => e
            errors << e.message
          end
        end
        errors
      end

      def forbidden
        render json: {error: 'Forbidden'}, status: :forbidden
      end

      def wrong_store
        render json: {error: 'Wrong store'}, status: :not_found
      end

      def invalid_data
        render json: {error: 'Invalid status'}, status: :bad_request
      end
    end
  end
end
