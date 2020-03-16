module Api
  module V1
    # Application Resource
    class ApplicationResource < JSONAPI::Resource
      abstract

      def custom_links(_)
        { self: nil }
      end
    end
  end
end
