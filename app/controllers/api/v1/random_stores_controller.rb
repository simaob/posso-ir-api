module Api
  module V1
    class RandomStoresController < StoresController
      def index
        if Rails.env.production?
          render json: {error: 'Endpoint not found'}, status: :not_found
        else
          result = apply_params(records)
          render json: RandomStoreSerializer.new(result).serialized_json
        end
      end
    end
  end
end
