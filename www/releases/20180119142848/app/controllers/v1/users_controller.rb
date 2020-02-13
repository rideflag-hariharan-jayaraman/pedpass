module V1
  class UsersController < V1::BaseController
    before_action :authorize_device_registration, only: :create
    skip_before_action :authenticate_device!, only: :create

    def create
      device_uuid = user_params.fetch(:devices_attributes) { [] }.first&.fetch(:uuid)

      if device = Device.find_by(uuid: device_uuid)
        render_resource device.user
      else
        render_create User.create(user_params)
      end
    end

    def show
      render_resource current_user
    end

    private

    def user_params
      params.require(:user).permit(devices_attributes: [:uuid])
    end
  end
end
