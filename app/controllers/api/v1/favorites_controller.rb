module Api
  module V1
    class FavoritesController < ApiController
      def create
        return if no_user
        return if no_store

        favorite = Favorite.new(store: @store, user: @user)
        if favorite.save
          render json: StoreSerializer.new(favorite.store).serialized_json, status: :created
        else
          render json: {errors: favorite.errors.full_messages.join(', ')}, status: :conflict
        end
      end

      def destroy
        return if no_user

        favorite = Favorite.find_by id: params[:id]
        return render json: {errors: "Couldn't find favorite"}, status: :not_found unless favorite
        unless @user == favorite.user
          return render json: {errors: "Favorite doesn't belong to user"}, status: :forbidden
        end

        if favorite.destroy
          render json: {}, status: :no_content
        else
          render json: {errors: favorite.errors.full_messages.join(', ')}, status: :conflict
        end
      end

      def index
        favorites = context[:current_user].favorite_stores
        render json: StoreSerializer.new(favorites).serialized_json
      end

      private

      def no_user
        @user = context[:current_user]
        return false if @user&.confirmed?

        render json: {error: 'You must be authenticated'}, status: :forbidden
        true
      end

      def no_store
        @store = Store.find params.dig(:data, :attributes, :"store-id")
        false
      rescue ActiveRecord::RecordNotFound
        render json: {error: 'Store not found'}
        true
      end
    end
  end
end
