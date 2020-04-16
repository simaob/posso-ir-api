module Api
  module V1
    class StatusStoreOwnersController < ApiController
      def create
        unless context[:current_user].store_owner? && user_owns_store?
          render(json: {error: 'not authorized'}, status: 401) and return
        end
        super
      end

      private

      def user_owns_store?
        context[:current_user].stores.pluck(:id).include?(params.dig(:data, :attributes, "store-id")&.to_i)
      end
    end
  end
end
