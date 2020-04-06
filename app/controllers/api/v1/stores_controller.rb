module Api
  module V1
    class StoresController < ApiController
      # Example of how to manage the stores in the controller,
      # in case the PG::Result can't be properly parsed by AR in the resource
      # (this can also be made in the model)

      # def show
      #   location = Location.where(published: true).find_by slug: params[:id]
      #   record_not_found && return unless location
      #
      #   resource = resource_with_locations(location)
      #   render json: resource_with_count(location, resource)
      # end
      #
      # private
      #
      # def resource_with_locations(location)
      #   include_options_blacklist = [location.location_type.pluralize.underscore]
      #   include_resources = params[:include].split(',').map(&:underscore) - include_options_blacklist rescue []
      #
      #   JSONAPI::ResourceSerializer
      #       .new(LocationResource, include: include_resources)
      #       .serialize_to_hash(LocationResource.new(location, context))
      # end
      #
      # def resource_with_count(location, resource)
      #   location_type = params[:count].keys.first rescue nil
      #   return resource unless location_type
      #   return resource unless Location::LOCATION_TYPES.include? location_type.singularize.camelize
      #   return resource if location_type.singularize.camelize == location.location_type
      #
      #   children_count = location.send(location_type.pluralize.underscore).count
      #   resource[:data]['attributes']['children_count'] = children_count
      #
      #   resource
      # end
    end
  end
end
