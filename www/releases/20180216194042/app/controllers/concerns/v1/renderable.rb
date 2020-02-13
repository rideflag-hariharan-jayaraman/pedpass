# This module serves as a set of helper methods to make rendering responses JSON
# API compliant.
module V1
  module Renderable
    # Lists a collection of data specific to how the JSON API would like it
    # formatted.
    #
    # Primarily used inside of #index actions.
    def render_collection(collection, meta = {})
      render_params = { json: collection, include: params[:include] }
      render_params.merge!(meta: meta) if meta.present?

      render render_params
    end

    # Will respond with a 201 if it was persisted. If not, then we render an
    # error.
    #
    # Primarily used inside of #create actions.
    def render_create(resource, meta = {})
      if resource.persisted?
        render_params = { json: resource, status: 201, include: params[:include] }
        render_params.merge!(meta: meta) if meta.present?

        render render_params
      else
        render_error resource
      end
    end

    # Renders a resource specific to how a request asks for it.
    #
    # Primarily used inside of #show actions.
    def render_resource(resource)
      render json: resource, include: params[:include]
    end

    # Will use the {ActiveModel::Serializer::ErrorSerializer} to render an error
    # for a resource.
    def render_error(resource)
      error_serializer = ActiveModel::Serializer::ErrorSerializer
      render status: 422, json: resource, serializer: error_serializer
    end
  end
end
