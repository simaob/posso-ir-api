module Api
  module V1
    class StatusEstimationsController < ExternalApiController
      def create
        return forbidden unless current_user.admin?

        store = Store.find_by(id: params['store-id'])
        status = params['status']
        return wrong_store unless store
        return invalid_data if status.blank?

        estimation = StatusEstimation.create(status: status,
                                             store_id: store.id,
                                             updated_time: DateTime.current,
                                             valid_until: DateTime.current + 1.hour)
        if estimation.errors.any?
          render json: {error: estimation.errors.messages}, status: :unprocessable_entity
        else
          render json: {message: "Added status for store: #{store.id}"}, status: :created
        end
      end

      private

      def forbidden
        render json: {error: 'Forbidden'}, status: :forbidden
      end

      def wrong_store
        render json: {error: 'Wrong store'}, status: :not_found
      end

      def invalid_data
        render json: {error: 'Invalid status'}, status:  :bad_request
      end
    end
  end
end
