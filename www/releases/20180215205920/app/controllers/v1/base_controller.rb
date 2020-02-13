module V1
  class BaseController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
    include ActiveSupport::SecurityUtils

    include V1::Renderable

    before_action :set_locale
    before_action :deserialize_json_api_params, if: :json_api_request?
    before_action :set_content_type_to_json_api, if: :json_api_request?

    # before_action :authenticate_device!
    before_action :authenticate_user_from_token!

    protected

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

    def authenticate_optional_user_from_token!
      return unless http_token

      authenticate_user_from_token!
    end

    def authenticate_user_from_token!
      return render_unauthorized unless user_id_in_token?

      @current_user = User.find(auth_token[:user_id])
      @current_device = Device.find_by(api_key: auth_token[:device_token])

      raise JWT::VerificationError unless @current_device.present?
    rescue JWT::VerificationError, JWT::DecodeError
      render_unauthorized
    end

    def set_locale
      logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
      I18n.locale = extract_locale_from_accept_language_header
      logger.debug "* Locale set to '#{I18n.locale}'"
    end

    private

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

    def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end

    def auth_token
      @auth_token ||= JsonWebToken.decode(http_token)
    end

    def user_id_in_token?
      http_token && auth_token && auth_token[:user_id].to_i
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

    def extract_locale_from_accept_language_header
      lang = request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
      lang.present? && lang.match(/en|fr|es/) ? lang :  I18n.default_locale
    end
  end
end
