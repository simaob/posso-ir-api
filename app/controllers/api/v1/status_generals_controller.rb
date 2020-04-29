module Api
  module V1
    class StatusGeneralsController < ApiController
      def index
        return super if params.dig('filter', 'store_id')

        render json: {error: 'Must supply store_id filter'}, status: :unprocessable_entity
      end
    end
  end
end
