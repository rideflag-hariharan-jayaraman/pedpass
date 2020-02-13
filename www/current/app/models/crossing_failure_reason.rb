class CrossingFailureReason < ApplicationRecord
  INVALID = 'invalid_crosswalk'.freeze
  NEAR_FAR = 'near_far'.freeze
  FAR_NEAR = 'far_near'.freeze
  FAR_FAR = 'far_far'.freeze

  validates :description, :failure_code, :failure_reason, presence: true

  def to_s
    failure_reason
  end

  def self.get_failure_reason(crosswalk_found, near1, near2)
    failure_reason = nil

    # Find the failure reason
    if !crosswalk_found
      failure_reason = CrossingFailureReason.find_by(failure_code: INVALID)
    elsif near1 && !near2
      failure_reason = CrossingFailureReason.find_by(failure_code: NEAR_FAR)
    elsif !near1 && near2
      failure_reason = CrossingFailureReason.find_by(failure_code: FAR_NEAR)
    elsif !near1 && !near2
      failure_reason = CrossingFailureReason.find_by(failure_code: FAR_FAR)
    end

    failure_reason
  end
end
