module Api
  module V1
    class BeachesController < ExternalApiController
      def index
        return forbidden unless current_user.any_admin?

        beaches = Store.beach.live

        render json: BeachSerializer.new(beaches).serialized_json
      end

      def general_status
        return forbidden unless current_user.any_admin?

        beaches = Store.beach.live.includes(:status_general, :beach_configuration)

        render json: BeachGeneralStatusSerializer.new(beaches).serialized_json
      end

      private

      def forbidden
        render json: {error: 'Forbidden'}, status: :forbidden
      end
    end
  end
end
