module Api
  module V1
    class UserResource < ApplicationResource
      caching

      attributes :name, :email, :password

      def self.records(options = {})
        current_user = options[:context][:current_user]
        current_user
      end

      def fetchable_fields
        super - [:password]
      end

      def self.updatable_fields(context)
        super - [:id, :email]
      end

      exclude_links :default
    end
  end
end
