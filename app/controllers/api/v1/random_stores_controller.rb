module Api
  module V1
    class RandomStoresController < StoresController
      def index
        result = apply_params(records)
        options = {}
        options[:include] = [:beach_configuration]
        render json: RandomStoreSerializer.new(result, options).serialized_json
      end
    end
  end
end
