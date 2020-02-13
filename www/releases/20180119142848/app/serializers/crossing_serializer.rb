class CrossingSerializer < ApplicationSerializer
  attributes :success

  belongs_to :crossing_failure_reason
  has_one :crosswalk
  has_one :user
end
