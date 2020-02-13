class UserPoints
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def total_points
    user.crossings.sum(&:points_earned) - user.redemptions.sum(&:points)
  end

  def award_points(crosswalk)
    return 0 unless crosswalk.present?

    intersection = crosswalk.corners.first.intersection
    user.crossings
      .where('crosswalk_id IN (?)', intersection.corners.map(&:crosswalks).flatten.map(&:id).uniq)
      .where(success: true)
      .where('created_at >= ?', Time.current - intersection.throttle_points_delay_minutes.minutes)
      .count == 0 ? 1 : 0
  end
end
