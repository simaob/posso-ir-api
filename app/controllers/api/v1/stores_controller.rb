module Api
  module V1
    class StoresController < ApiController
      def index
        # if a store owner code was passed and that user exists and is a store owner
        # or otherwise if there's a filter by location present
        if store_owner_code && !context[:current_user]&.store_owner?
          render(json: {error: 'you are not authorized to list all available stores'}, status: :forbidden)
          return
        elsif !store_owner_code && !params.dig(:filter, :location)
          render(json: {error: 'filter[location]={lat,lng} is mandatory for this request'}, status: :forbidden)
          return
        end

        location = params[:filter][:location].split(',')

        result = records.retrieve_closest(*location)
        render json: result.to_json
      end

      private

      def records
        if @current_user&.store_owner?
          @current_user.stores.available
        else
          Store.available.includes(:week_days)
        end
      end
    end
  end
end
