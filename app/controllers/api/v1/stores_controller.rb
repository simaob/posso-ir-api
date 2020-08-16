module Api
  module V1
    class StoresController < ApiController
      PAGE_NUMBER = 0
      PAGE_SIZE = 100
      MAX_PAGE_SIZE = 1000

      before_action :validate_request, only: :index

      def index
        result = apply_params(records)
        options = {}
        options[:include] = [:beach_configuration]
        render json: StoreSerializer.new(result, options).serialized_json
      end

      private

      def validate_request
        # if a store owner code was passed and that user exists and is a store owner
        if store_owner_code && !context[:current_user]&.store_owner?
          render(json: {error: 'you are not authorized to list all available stores'}, status: :forbidden)
        end
      end

      def apply_params(results)
        results = filters(results)
        results = pagination(results)
        results
      end

      def filters(results)
        location = params.dig(:filter, :location)&.split(',')
        store_type = params.dig(:filter, :'store-type')
        search = params.dig(:filter, :search)

        store_type = if Store.store_types.include?(store_type)
                       store_type
                     elsif store_type == 'others' # all but beach, supermarket, pharmacy, restaurant
                       [:gas_station, :bank, :kiosk, :coffee, :other, :atm, :post_office]
                     end
        results = results.retrieve_closest(*location) if location
        results = results.where(store_type: store_type) if store_type
        results = results.api_text_search(search) if search
        results.where.not(latitude: nil).where.not(longitude: nil)
      end

      def pagination(results)
        page_size = [(params.dig(:page, :size) || PAGE_SIZE).to_i, MAX_PAGE_SIZE].min
        offset = (params.dig(:page, :number) || PAGE_NUMBER) * page_size

        results = results.limit(page_size).offset(offset)
        results
      end

      def records
        if @current_user&.store_owner?
          @current_user.stores.available
        else
          Store.available.includes(:current_day, :beach_configuration)
        end
      end
    end
  end
end
