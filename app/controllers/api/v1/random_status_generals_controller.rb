module Api
  module V1
    class RandomStatusGeneralsController < ApiController
      def index
        unless Rails.env.production?
          return super if params.dig('filter', 'store_id')

          render json: {error: 'Must supply store_id filter'}, status: 422
        else
          render json: {error: 'Endpoint not found'}, status: 404
        end
      end
    end
  end
end
