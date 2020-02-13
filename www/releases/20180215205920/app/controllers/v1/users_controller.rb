module V1
  class UsersController < V1::BaseController
    before_action :authorize_device_registration, only: :create
    skip_before_action :authenticate_user_from_token!, only: :create

    def create
      create_params = user_params
      create_params.merge!(devices_attributes: [{}]) unless create_params[:devices_attributes].present?
      create_params.merge!(profile_attributes: {}) unless create_params[:profile_attributes].present?

      render_create User.create(create_params)
    end

    def show
      render_resource current_user
    end

    def update
      if current_user.update user_update_params
        render_resource current_user
      else
        render_error current_user
      end
    end

    private
    def user_params
      params.require(:user).permit(
        :email, :password,
        devices_attributes: [:uuid],
        profile_attributes: [:gender, :age_range, :student_id]
      )
    end

    def user_update_params
      update_params = params.require(:user).permit(
        :email, profile_attributes: [:gender, :age_range, :student_id]
      )

      if update_params[:profile_attributes].present?
        update_params[:profile_attributes]['id'] = current_user.profile.id
      end

      update_params
    end
  end
end
