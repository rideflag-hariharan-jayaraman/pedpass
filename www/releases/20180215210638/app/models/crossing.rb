# A matched and detected crossing of a {User}. This basically means, that yes,
# someone has crossed the road appropriately.
class Crossing < ApplicationRecord
  include ClassyEnum::ActiveRecord

  has_many :detected_nodes
  has_many :detected_corners, through: :detected_nodes

  belongs_to :crosswalk, optional: true
  belongs_to :user

  classy_enum_attr :message, allow_nil: true

  # Returns ARRAY of Crossing objects
  def self.process_detected_corner_data(options)
    # get values from options hash
    current_user = options[:current_user]
    device_id = options[:device_id]
    trip_is_complete = options[:trip_is_complete] || false
    if trip_is_complete && options[:coordinates].present?
      final_latitude = options[:coordinates][:latitude]
      final_longitude = options[:coordinates][:longitude]
    end

    crossings = []
    device = current_user.devices.find(device_id)

    # Get unprocessed detected corners for this device
    unprocessed_detected_corners = device.detected_corners.where(processed: false)

    # Find each corner object with the smallest beacon_distance
    unique_detected_corners = DetectedCornerFilter.new(
      unprocessed_detected_corners
    ).uniq_filtered_set

    # Sort this by created_at ASC to ensure we look at the corners in sequence
    unique_detected_corners_in_seq = unique_detected_corners.sort_by { |dc| dc[:created_at] }

    # local bool to let us know later if a success was found.
    found_success = false

    # Traverse the list of unique_detected_corners_in_seq by groups of 2
    # eg. if we have corner objects with IDs: [1, 2, 3], we want to iterate with (1,2) and (2,3)
    unique_detected_corners_in_seq.each_cons(2) do |detected_corner1, detected_corner2|
      next if detected_corner1.corner.intersection_id != detected_corner2.corner.intersection_id
      # Ignore these 2 detected corners if the created_at delta is > Crossing.crossing_grace_period_seconds
      difference_in_seconds = (detected_corner2.created_at - detected_corner1.created_at) / 1.minute
      next if (difference_in_seconds > Crossing.crossing_grace_period_seconds)

      # Find any Crosswalks based on these corners
      crosswalk = Crossing.get_crosswalk_for_corners(detected_corner1.corner, detected_corner2.corner)

      evaluation = CrossingEvaluation.new(
        current_user, crosswalk, detected_corner1, detected_corner2
      )

      found_success = true if evaluation.successful_crossing?  # only set this bool to TRUE under the specific condition, otherwise do not update its previously value

      crossings << new(
        user_id: current_user.id, crosswalk: crosswalk,
        success: evaluation.successful_crossing?, message: evaluation.message,
        detected_corners: [detected_corner1, detected_corner2],
        points_earned: evaluation.points
      )
    end

    # find the potential FINAL Failed Crossing based on GPS distances IFF the trip is complete
    final_crossing = Crossing.get_final_crossing_failure_based_on_gps(current_user, unique_detected_corners_in_seq.last, final_latitude, final_longitude) if trip_is_complete
    crossings << final_crossing if final_crossing.present?

    # if trip is complete OR we found a success, save the crossings, mark data as processed and return the sorted crossings array
    if trip_is_complete || found_success
      # save each Crossing object
      ActiveRecord::Base.transaction do
        if crossings.present?
          # save all DetectedCorner objects for this "trip"
          crossings.each(&:save!)

          # Order by DESC created_at
          crossings.sort_by{ |c| c[:created_at] }.reverse
        end
        # Process these detected corners
        unprocessed_detected_corners.update_all(processed: true)

        return crossings
      end
    else
      # Return empty array since we found no success and Trip was NOT "complete"
      return []
    end
  end

  private
  def self.crossing_grace_period_seconds
    Setting.crossing_grace_period_seconds.to_f.seconds
  end

  def self.get_final_crossing_failure_based_on_gps(current_user, last_detected_corner, final_latitude, final_longitude)
    # if we don't get a last corner, or lat/long, return
    return if last_detected_corner.blank? || final_latitude.blank? || final_longitude.blank?

    # find the potential FINAL Failed Crossing based on GPS distances
    last_corner = last_detected_corner.corner

    # Using the Last known corner, we find its Intersection and then all Corners at that Intersection.
    # We can then find the closest Corner to the user's final Lat/Long
    closest_corner = last_corner.intersection.corners.closest(origin: [final_latitude, final_longitude])&.first

    # if we didn't a new closest_corner or
    # if the newly found closest_corner is the same as the last_corner, then the user likely did not cross the street, so just return
    return if closest_corner.blank? || (closest_corner.id == last_corner.id)

    # check if the 2 corners form a Crosswalk
    crosswalk = Crossing.get_crosswalk_for_corners(last_corner, closest_corner)

    # find the failure reason based on the last known corner and assuming we are NOT near the closest_beacon
    evaluation = CrossingEvaluation.new(current_user, crosswalk, last_detected_corner, nil)

    return new(user_id: current_user.id, crosswalk: crosswalk, success: false, message: evaluation.message, detected_corners: [last_detected_corner])
  end

  def self.get_crosswalk_for_corners(corner1, corner2)
    # Find any Crosswalks based on these corners
    corner_ids = [corner1.id, corner2.id]
    Crosswalk.with_corners(corner_ids)
  end
end
