module Api
  module V1
    class AuthController < ApiController
      before_action :set_attrs

      def register
        if User.find_by(email: @attrs[:email]) || @attrs[:email].blank?
          render json: {error: 'email already registered'}, status: :unauthorized and return
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
          render json: {success: 'User created successfully'}, status: :created
        end
      end

      def login
        user = User.where.not(email: nil).find_by(email: @attrs[:email])
        if user&.valid_password?(@attrs[:password])
          user.app_uuid = context[:app_uuid]
          user.save

          # Invalidate other users on the same devise
          # rubocop:disable Rails/SkipsModelValidations
          User.where.not(id: user.id).where(app_uuid: user.app_uuid).update_all(app_uuid: nil)
          # rubocop:enable Rails/SkipsModelValidations
          render json: {success: 'login successful'}, status: :ok
        else
          render json: {error: 'wrong password'}, status: :unauthorized
        end
      rescue StandardError
        render json: {error: 'authentication failed'}, status: :unauthorized
      end

      def logout
        if context[:current_user]&.email.present?
          context[:current_user].update(app_uuid: "#{context[:current_user].app_uuid}_old_#{Time.current.to_i}")
          render json: {success: 'user logged out'}, status: :ok
        else
          render json: {error: 'user not logged in'}, status: :unauthorized
        end
      end

      private

      def set_attrs
        @attrs = params[:data][:attributes]
      end
    end
  end
end
