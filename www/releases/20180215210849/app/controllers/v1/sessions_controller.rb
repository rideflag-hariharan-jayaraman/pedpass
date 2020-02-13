# frozen_string_literal: true
require 'json_web_token'

module V1
  class SessionsController < V1::BaseController
    skip_before_action :authenticate_user_from_token!

    def create
      @user = User.find_for_database_authentication(email: params[:session][:email])
      render(json: invalid_login_attempt, status: :unauthorized) && return unless @user

      # create device if it doesn't exist
      @device = @user.devices.find_or_create_by! uuid: params[:session][:device]

      if @user.valid_password?(params[:session][:password]) && @device.present?
        sign_in :user, @user

        @current_device = @user

        render json: payload(@user)
      else
        render(json: invalid_login_attempt, status: :unauthorized) && return
      end
    end

    def oauth
      # Any attempt to connect without token is treated as invalid login
      return invalid_login_attempt unless auth_params[:auth_token].present?

      # Interact with Oauth Service to get user data
      begin
        client = Oauth::Client.new(params[:auth_provider], auth_params[:auth_token])
        auth_user = client.fetch
      rescue StandardError => e
        render(json: invalid_login_attempt, status: :unauthorized) && return
      end

      @user = User.find_by email: auth_user.email

      # check if user exists
      if @user.present?
        @device = @user.devices.find_or_create_by(uuid: auth_params[:device])

        identity = @user.identities.where(provider: client.provider)
        if identity.present?
          identity.update uid: client.token
        else
          Identity.create!(
            user: @user, provider: client.provider, uid: client.token
          )
        end
      else # create new user and identity
        @user = Identity.user_from_omniauth(client)
        @device = @user.devices.create(uuid: auth_params[:device])
      end

      if @user.persisted? && @user.valid? ||
        @device.persisted? && @device.valid?
        sign_in :user, @user
        render json: payload(@user)
      else
        render_error @user
      end
    end

    private
    def payload(user)
      {
        data: {
          type: 'sessions',
          attributes: {
            token: JsonWebToken.encode(
              user_id: user.id, device_token: @device.api_key,
              exp: (Time.zone.now + 1.month).to_i
            ),
            confirmed: user.confirmed?,
            'profile-attributes': {
              gender: user.profile.gender,
              'age-range': user.profile.age_range,
              'student-id': user.profile.student_id
            }
          }
        }
      }
    end

    def auth_params
      (params.require(:auth).permit(:auth_token, :device)) || {}
    end

    def invalid_login_attempt(realm = 'Application')
      warden.custom_failure!
      self.headers['WWW-Authenticate'] = %(Token realm="#{realm.delete('"')}")
      {
        errors: [{
          status: '401',
          title: 'Unauthorized',
          message: I18n.t('custom_responses.unauthorized')
          }]
        }
    end
  end
end
