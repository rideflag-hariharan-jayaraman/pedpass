class CrossingEvaluation
  attr_reader :user, :crosswalk, :detected_corner1, :detected_corner2
  def initialize(user, crosswalk, detected_corner1, detected_corner2)
    @user = user
    @crosswalk = crosswalk
    @detected_corner1 = detected_corner1
    @detected_corner2 = detected_corner2
  end

  def points
    user_points.award_points(crosswalk)
  end

  # => SUCCESS if near TWO beacons and corners make a valid Crosswalk
  # =>  Covers: NEAR && NEAR when Corners DO make a valid Crosswalk

  # => FAILURE if corners do not make a valid Crosswalk (diagonal street crossing) or
  # =>         if beacon_distances are BOTH NOT <= Crossing.beacon_range_near
  # =>  Covers: NEAR && NEAR but Corners DO NOT form a valid Crosswalk
  # =>          NEAR and FAR
  # =>          FAR and NEAR
  # =>          FAR and FAR
  def message
    crosswalk_found = crosswalk.present?

    if !crosswalk_found
      return Message::FailInvalidCrosswalk.new
    elsif near1 && !near2
      return Message::FailNearFar.new
    elsif !near1 && near2
      return Message::FailFarNear.new
    elsif !near1 && !near2
      return Message::FailFarFar.new
    elsif successful_crossing? && points == 0
      return Message::AlreadyCrossed.new
    elsif successful_crossing?
      return Message::Crossing.new
    end
  end

  def successful_crossing?
    crosswalk.present? && near1 && near2
  end

  private
  def user_points
    @user_points ||= UserPoints.new(user)
  end

  def near1
    detected_corner1&.near_corner? || false
  end

  def near2
    detected_corner2&.near_corner? || false
  end
end
