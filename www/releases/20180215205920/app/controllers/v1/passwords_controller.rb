module V1
  class PasswordsController < V1::BaseController
    before_action :authenticate_optional_user_from_token!, only: [:update]
    skip_before_action :authenticate_user_from_token!

    def create
      @user = User.find_by_email(params[:password][:email])

      if @user.present?
        @user.send_reset_password_instructions

        render json: payload
      else
        render  json: {
          errors: [
            { status: '422', title: 'Email not found', source: { pointer: '/data/attributes/email' } }
          ]
        }, status: 422
      end
    end

    def update
      if params[:password].key? :reset_password_token
        update_password_from_token
      else
        update_password_from_password
      end
    end

    private

    def update_password_from_token
      recoverable = User.reset_password_by_token(params[:password])
      if recoverable.errors.blank?
        render json: recoverable
      else
        render_error(recoverable)
      end
    end

    def update_password_from_password
      if current_user.update_with_password(password_params)
        render json: current_user
      else
        render_error(current_user)
      end
    end

    def payload
      {
        data: [{ type: 'passwords' }]
      }
    end

    def password_params
      params.require(:password).permit(:password, :password_confirmation, :current_password)
    end
  end
end
