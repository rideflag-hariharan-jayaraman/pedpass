module V1
  class DevicesController < V1::BaseController
    before_action :authorize_device_registration, only: :create
    skip_before_action :authenticate_device!, only: :create

    def create
      render_create Device.create(device_params)
    end

    def show
      render_resource current_device
    end

    private

    def device_params
      params.require(:device).permit(:uuid, :user_id)
    end
  end
end
