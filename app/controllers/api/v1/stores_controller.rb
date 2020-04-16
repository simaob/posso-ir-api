module Api
  module V1
    class StoresController < ApiController
      def index
        # if a store owner code was passed and that user exists and is a store owner
        # or otherwise if there's a filter by location present
        if store_owner_code && !context[:current_user]&.store_owner?
          render(json: {error: 'you are not authorized to list all available stores'}, status: 403) and return
        elsif !store_owner_code && !params.dig(:filter, :location)
          render(json: {error: 'filter[location]={lat,lng} is mandatory for this request'}, status: 403) and return
        end

        super
      end
    end
  end
end
