module Api
  module V1
    class UsersController < ApiController
      include Badgeable

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
        @user.increase_login_counter
        random_badges_for(@user) unless Rails.env.production?
        options = {}
        options[:include] = [:stores]
        render json: UserSerializer.new(@user, options).serialized_json
      end

      def destroy
        sign_out(@user)
        @user.soft_destroy!
        render json: {success: 'user account removed'}, status: :ok
      end

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
