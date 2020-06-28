module Api
  module V1
    class FavoriteResource < ApplicationResource
      caching

      attributes :store_id, :created_at

      has_one :user
      has_one :store

      filters :user, :store

      def self.records(options = {})
        current_user = options[:context][:current_user]
        current_user&.favorites
      end

      exclude_links :default
    end
  end
end
