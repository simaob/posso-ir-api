module Api
  module V1
    class RandomStoresController < StoresController
      def index
        result = apply_params(records)
        render json: RandomStoreSerializer.new(result).serialized_json
      end
    end
  end
end
