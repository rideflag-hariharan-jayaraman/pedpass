module V1
  class DetectedCornersController < V1::BaseController
    def index
      render_collection current_device.detected_corners.for_sub_user(sub_user_id)
    end

    def create
      # attach device id and sub_user_id
      detected_corner_params.merge! device_id: current_device.id
      detected_corner_params.merge! sub_user_id: sub_user_id if sub_user_id.present?

      batch = BeaconBatch::Base.new detected_corner_params
      detected_corner = batch.process

      render_create(detected_corner, !detected_corner.present? ? {} : {
        success: detected_corner.near_corner? && successful_crossing?,
        approaching: detected_corner.approaching_corner?
      })
    end

    def show
      render_resource current_device.detected_corners.for_sub_user(sub_user_id).find(params[:id])
    end

    private
    def detected_corner_params
      @detected_corner_params ||= params.require(:detected_corner).permit(
        :latitude, :longitude, :accuracy, :heading, :speed, :sub_user_id,
        detected_beacons: [
          :ibeacon_uuid, :ibeacon_minor, :ibeacon_major,
          :beacon_proximity, :beacon_distance, :beacon_battery
        ],
      )
    end

    def successful_crossing?
      # Look at the currently unprocessed data to find any Successful crossings
      options = {
        current_user: current_user,
        sub_user_id: sub_user_id,
        device_id: current_device&.id,
        trip_is_complete: false
      }

      Crossing.process_detected_corner_data(options).map(&:success).any?
    end

    def near_corner?(detected)
      detected.corner.present? && detected.beacon_distance <= detected.corner.near_limit
    end

    def approaching_corner?(detected)
      detected.corner.present? && !near_corner?(detected) &&
      detected.beacon_distance <= detected.corner.approaching_limit
    end
  end
end
