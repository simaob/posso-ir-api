module Api
  module V1
    class AuthController < ApiController
      include Badgeable

      before_action :set_attrs
      skip_before_action :verify_authenticity_token

      def register
        if User.find_by(email: @attrs[:email]) || @attrs[:email].blank?
          render json: {error: 'email already registered'}, status: :forbidden and return
        end

        new_user = nil

        User.transaction do
          # archive old user
          user = context[:current_user]
          app_uuid = context[:app_uuid]
          user&.update(app_uuid: "#{user.app_uuid}_old_#{Time.current.to_i}")

          new_user = User.create(
            app_uuid: app_uuid,
            name: @attrs[:name],
            email: @attrs[:email],
            password: @attrs[:password]
          )
        end
        if new_user.errors.any?
          render json: {error: "unable to create user: #{new_user.errors.full_messages.join(', ')}"}, status: :conflict
        else
          # confirm user straight away if using staging
          new_user.confirm if Rails.env.staging?
          render json: UserSerializer.new(new_user).serialized_json, status: :created
        end
      end

      def login
        user = User.where.not(email: nil).find_by(email: @attrs[:email])
        if user&.valid_password?(@attrs[:password])
          user.app_uuid = context[:app_uuid]
          sign_in(user)
          user.save

          # Invalidate other users on the same devise
          # rubocop:disable Rails/SkipsModelValidations
          User.where.not(id: user.id).where(app_uuid: user.app_uuid).update_all(app_uuid: nil)
          random_badges_for(user) unless Rails.env.production?
          options = {}
          options[:include] = [:stores]
          # rubocop:enable Rails/SkipsModelValidations
          render json: UserSerializer.new(user, options).serialized_json, status: :ok
        else
          render json: {error: 'wrong password'}, status: :forbidden
        end
      rescue StandardError
        render json: {error: 'authentication failed'}, status: :forbidden
      end

      def logout
        if context[:current_user]&.email.present?
          context[:current_user].update(app_uuid: "#{context[:current_user].app_uuid}_old_#{Time.current.to_i}")
          sign_out(context[:current_user])
          render json: {success: 'user logged out'}, status: :ok
        else
          render json: {error: 'user not logged in'}, status: :forbidden
        end
      end

      private

      def set_attrs
        @attrs = params.dig(:data, :attributes) || params.dig(:auth, :data, :attributes)
      end
    end
  end
end
