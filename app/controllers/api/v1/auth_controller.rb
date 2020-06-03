module Api
  module V1
    class AuthController < GeneralApiController
      def register
        if User.find_by(email: params[:email]) || params[:email].blank?
          render json: {error: 'email already registered'}, status: :unauthorized and return
        end

        new_user = nil

        User.transaction do
          # archive old user
          user = context[:current_user]
          app_uuid = user.app_uuid
          user.update(app_uuid: "#{app_uuid}_old_#{Time.current.to_i}")

          new_user = User.create(
            app_uuid: app_uuid,
            email: params[:email],
            password: params[:password],
            password_confirmation: params[:password],
            phone: params[:phone]
          )
        end
        if new_user.errors.any?
          render json: {error: "unable to create user: #{new_user.errors.full_messages.join(', ')}"}, status: :conflict
        else
          render json: {success: 'User created successfully'}, status: :created
        end
      end

      def login
        user = User.where.not(email: nil).find_by(email: params[:email])
        if user&.valid_password?(params[:password])
          user.app_uuid = context[:current_user].app_uuid
          user.save
          render json: {success: 'login successful'}, status: :success
        else
          render json: {error: 'wrong password'}, status: :unauthorized
        end
      rescue StandardError
        render json: {error: 'authentication failed'}, status: :unauthorized
      end

      def logout
        if context[:current_user].email
          context[:current_user].update(app_uuid: "#{context[:current_user].app_uuid}_old_#{Time.current.to_i}")
          render json: {success: 'user logged out'}, status: :success
        else
          render json: {error: 'user not logged in'}, status: :unauthorized
        end
      end
    end
  end
end
