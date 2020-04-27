module Api
  module V1
    class StatusPhoneController < ExternalApiController
      def create
        phone = params['phone']
        store = Phone.find_by(phone_number: phone, active: true)&.store
        return wrong_phone unless store
        return forbidden_store unless current_user.stores.pluck(:id)&.include?(store.id)

        status = case params['status']
                 when '1', 1
                   0
                 when '2', 2
                   5
                 when '3', 3
                   10
                 end

        StatusStoreOwner.create!(status: status,
                                 store_id: store.id, updated_time: DateTime.now)

        render json: {message: "Added status for store: #{store.id}"}, status: 201
      rescue StandardError
        render json: {error: 'Malformed request'}, status: 400
      end

      private

      def forbidden_store
        render json: {error: "You don't own this store"}, status: 403
      end

      def wrong_phone
        render json: {error: 'Invalid phone number'}, status: 406
      end
    end
  end
end
