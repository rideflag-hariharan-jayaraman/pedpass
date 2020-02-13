module V1
  class BaseController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods
    include ActiveSupport::SecurityUtils

    include V1::Renderable

    before_action :deserialize_json_api_params, if: :json_api_request?
    before_action :set_content_type_to_json_api, if: :json_api_request?

    before_action :authenticate_device!

    protected

    attr_reader :user_id, :sub_user_id, :api_key
    attr_accessor :current_device, :current_user

    def render_unauthorized
      headers['WWW-Authenticate'] = 'Token realm="Application"'

      render status: 401, json: {
        errors: [
          {
            title: 'Unauthorized',
            detail: 'User ID or API Key is invalid.'
          }
        ]
      }
    end

    private

    def authenticate_device!
      # TODO: Remove sub_user_id post PoC
      @user_id, @sub_user_id, @api_key = device_token_header
      user = User.find_by(id: @user_id)
      device = user&.devices&.find_by(api_key: api_key)

      if device.present? && api_key.present? && secure_compare(device.api_key, api_key)
        @current_device = device
        @current_user = user
      else
        render_unauthorized
      end
    end

    def device_token_header
      token = request.headers['Token']
      Base64.decode64(token).split(':') if token.present?
    end

    def authorize_device_registration
      token = Rails.application.secrets.device_registration_token
      return if token == params[:device_token]

      render status: 401, json: {
        errors: [
          {
            title: 'Unauthorized',
            detail: 'The token provided is invalid.'
          }
        ]
      }
    end

    def set_content_type_to_json_api
      ActiveModelSerializers.config.adapter = :json_api
      response.headers['Content-Type'] = 'application/vnd.api+json'
    end

    def deserialize_json_api_params
      result = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if result.any?
        type = params['data'].fetch('type', '').singularize.underscore
        params[type] = result
      end
    end

    def json_api_request?
      request.headers['Content-Type'] == 'application/vnd.api+json'
    end
  end
end
