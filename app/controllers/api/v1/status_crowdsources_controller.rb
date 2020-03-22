module Api
  module V1
    class StatusCrowdsourcesController < ApiController
      def index
        return super if params.dig('filter', 'store_id')

        render json: { error: 'Must supply store_id filter' }, status: 422
      end
    end
  end
end