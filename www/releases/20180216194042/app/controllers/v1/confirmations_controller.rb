module V1
  class ConfirmationsController < V1::BaseController
    skip_before_action :authenticate_user_from_token!

    def create
      @user = User.find_by_email(confirmation_params[:email])

      if @user.present?
        @user.resend_confirmation_instructions

        render json: payload
      else
        render  json: {
          errors: [
            { status: '422', title: 'Email not found', source: { pointer: '/data/attributes/email' } }
          ]
        }, status: 422
      end
    end

    private

    def payload
      {
        data: [
          { type: 'confirmations' }
        ]
      }
    end

    def confirmation_params
      params.require(:confirmation).permit(:email)
    end
  end
end
