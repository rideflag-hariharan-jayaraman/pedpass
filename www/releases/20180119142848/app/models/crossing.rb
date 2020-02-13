# A matched and detected crossing of a {User}. This basically means, that yes,
# someone has crossed the road appropriately.
class Crossing < ApplicationRecord
  has_many :detected_nodes
  has_many :detected_corners, through: :detected_nodes

  belongs_to :crossing_failure_reason, optional: true
  belongs_to :crosswalk, optional: true
  belongs_to :user

  validates :sub_user_id, presence: true

  scope :for_sub_user, -> (sub_user_id) { where(sub_user_id: sub_user_id) }

  # Returns ARRAY of Crossing objects
  def self.process_detected_corner_data(options)
    # get values from options hash
    current_user = options[:current_user]
    sub_user_id = options[:sub_user_id]
    device_id = options[:device_id]
    trip_is_complete = options[:trip_is_complete] || false
    if trip_is_complete && options[:coordinates].present?
      final_latitude = options[:coordinates][:latitude]
      final_longitude = options[:coordinates][:longitude]
    end

    crossings = []
    device = current_user.devices.find(device_id)

    # Get unprocessed detected corners for this device
    unprocessed_detected_corners = device.detected_corners.for_sub_user(sub_user_id).where(processed: false)
    unique_corner_ids = unprocessed_detected_corners.map(&:corner_id).uniq

    # Find each corner object with the smallest beacon_distance
    unique_detected_corners = []
    unique_corner_ids.each do |corner_id|
      unique_detected_corners << unprocessed_detected_corners.where(corner_id: corner_id).order(:beacon_distance).limit(1).first
    end

    # Sort this by created_at ASC to ensure we look at the corners in sequence
    unique_detected_corners_in_seq = unique_detected_corners.sort_by { |dc| dc[:created_at] }

    # local bool to let us know later if a success was found.
    found_success = false

    # Traverse the list of unique_detected_corners_in_seq by groups of 2
    # eg. if we have corner objects with IDs: [1, 2, 3], we want to iterate with (1,2) and (2,3)
    unique_detected_corners_in_seq.each_cons(2) do |detected_corner1, detected_corner2|
      # Ignore these 2 detected corners if the created_at delta is > Crossing.crossing_grace_period_seconds
      difference_in_seconds = (detected_corner2.created_at - detected_corner1.created_at) / 1.minute
      next if (difference_in_seconds > Crossing.crossing_grace_period_seconds)

      # Find any Crosswalks based on these corners
      crosswalk = Crossing.get_crosswalk_for_corners(detected_corner1.corner, detected_corner2.corner)

      # Check if beacon_distance <= BEACON_RANGE_NEAR
      near1 = detected_corner1.near_corner?
      near2 = detected_corner2.near_corner?

      # => SUCCESS if near TWO beacons and corners make a valid Crosswalk
      # =>  Covers: NEAR && NEAR when Corners DO make a valid Crosswalk

      # => FAILURE if corners do not make a valid Crosswalk (diagonal street crossing) or
      # =>         if beacon_distances are BOTH NOT <= Crossing.beacon_range_near
      # =>  Covers: NEAR && NEAR but Corners DO NOT form a valid Crosswalk
      # =>          NEAR and FAR
      # =>          FAR and NEAR
      # =>          FAR and FAR

      # We need to find a crosswalk and be near to TWO beacons
      successful_crossing = crosswalk.present? && near1 && near2
      found_success = true if successful_crossing  # only set this bool to TRUE under the specific condition, otherwise do not update its previously value

      failure_reason = CrossingFailureReason.get_failure_reason(crosswalk.present?, near1, near2)
      crossings << new(user_id: current_user.id, sub_user_id: sub_user_id, crosswalk: crosswalk, success: successful_crossing, crossing_failure_reason: failure_reason, detected_corners: [detected_corner1, detected_corner2])
    end

    # find the potential FINAL Failed Crossing based on GPS distances IFF the trip is complete
    final_crossing = Crossing.get_final_crossing_failure_based_on_gps(current_user, sub_user_id, unique_detected_corners_in_seq.last, final_latitude, final_longitude) if trip_is_complete
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

  def self.beacon_range_near
    Setting.beacon_range_near_meters.to_f
  end

  def self.crossing_grace_period_seconds
    Setting.crossing_grace_period_seconds.to_f.seconds
  end

  def self.get_final_crossing_failure_based_on_gps(current_user, sub_user_id, last_detected_corner, final_latitude, final_longitude)
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

    # determine if user was near the last known corner
    near_last_corner = last_detected_corner.beacon_distance <= Crossing.beacon_range_near

    # find the failure reason based on the last known corner and assuming we are NOT near the closest_beacon
    failure_reason = CrossingFailureReason.get_failure_reason(crosswalk.present?, near_last_corner, false)

    return new(user_id: current_user.id, sub_user_id: sub_user_id, crosswalk: crosswalk, success: false, crossing_failure_reason: failure_reason, detected_corners: [last_detected_corner])
  end

  def self.get_crosswalk_for_corners(corner1, corner2)
    # Find any Crosswalks based on these corners
    corner_ids = [corner1.id, corner2.id]
    Crosswalk.with_corners(corner_ids)
  end
end
