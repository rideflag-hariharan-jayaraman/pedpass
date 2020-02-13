module V1
  class CrossingsController < V1::BaseController
    def index
      crossings = current_user.crossings.order("created_at DESC")
      successes = crossings.select(&:success).count

      render_collection crossings, success_meta
    end

    def show
      render_resource current_user.crossings.find(params[:id])
    end

    def check_for_success
      # Look at the currently unprocessed data to find any Successful crossings
      options = {
        current_user: current_user,
        device_id: current_device&.id,
        trip_is_complete: false
      }

      crossings = Crossing.process_detected_corner_data(options)
      render_collection crossings
    end

    def completed
      options = {
        current_user: current_user,
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
      successes = current_user.crossings.where(success: true).count
      total = current_user.crossings.count

      {
        total_points: UserPoints.new(current_user).total_points,
        success_rating: successes == 0 ? '0' : (
          100 * (successes / total.to_f)
        ).round.to_s
      }
    end
  end
end
