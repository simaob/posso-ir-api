module Api
  module V1
    class StatusCrowdsourceUsersController < ApiController
      def context
        super.merge({store_id: params.dig(:data, :attributes, :'store-id')})
      end
    end
  end
end
