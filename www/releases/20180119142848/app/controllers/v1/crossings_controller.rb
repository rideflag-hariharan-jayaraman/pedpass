module V1
  class CrossingsController < V1::BaseController
    def index
      crossings = current_user.crossings.for_sub_user(sub_user_id).order("created_at DESC")
      successes = crossings.select(&:success).count

      render_collection crossings, success_meta
    end

    def show
      render_resource current_user.crossings.for_sub_user(sub_user_id).find(params[:id])
    end

    def check_for_success
      # Look at the currently unprocessed data to find any Successful crossings
      options = {
        current_user: current_user,
        sub_user_id: sub_user_id,
        device_id: current_device&.id,
        trip_is_complete: false
      }

      crossings = Crossing.process_detected_corner_data(options)
      render_collection crossings
    end

    def completed
      options = {
        current_user: current_user,
        sub_user_id: sub_user_id,
        device_id: current_device&.id,
        trip_is_complete: true,
        coordinates: {
          latitude: completed_params[:latitude],
          longitude: completed_params[:longitude]
        }
      }
      crossings = Crossing.process_detected_corner_data(options)
      render_collection crossings, success_meta
    end

    private
    def completed_params
      @completed_params ||= params.require(:completed).permit(
        :latitude, :longitude
      )
    end

    def success_meta
      successes = current_user.crossings
        .for_sub_user(sub_user_id).where(success: true).count
      total = current_user.crossings.for_sub_user(sub_user_id).count

      {
        total_points: successes,
        success_rating: successes == 0 ? '0' : (
          100 * (successes / total.to_f)
        ).round.to_s
      }
    end
  end
end
