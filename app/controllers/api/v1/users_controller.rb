module Api
  module V1
    class UsersController < ApiController
      before_action :ensure_user

      def update
        @user.attributes = user_params
        if @user.save
          render json: UserSerializer.new(@user).serialized_json, status: :ok
        else
          render json: {errors: @user.errors.full_messages.join(', ')}, status: :conflict
        end
      end

      def index
        render json: UserSerializer.new(@user).serialized_json
      end

      # TODO
      # def destroy
      # end

      private

      def user_params
        attrs = params.dig(:data, :attributes) || params.dig(:users, :data, :attributes)
        attrs.permit(:password, :name)
      end

      def ensure_user
        @user = context[:current_user]
        return false if @user&.confirmed?

        render json: {error: 'You must be authenticated'}, status: :forbidden
      end
    end
  end
end
