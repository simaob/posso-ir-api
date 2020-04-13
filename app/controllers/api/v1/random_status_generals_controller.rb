module Api
  module V1
    class RandomStatusGeneralsController < ApiController
      def index
        if Rails.env.production?
          render json: {error: 'Endpoint not found'}, status: 404
        else
          return super if params.dig('filter', 'store_id')

          render json: {error: 'Must supply store_id filter'}, status: 422
        end
      end
    end
  end
end
