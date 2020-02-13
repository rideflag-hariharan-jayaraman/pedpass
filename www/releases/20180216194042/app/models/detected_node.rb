# When a {Corner} is detected and logged in the {DetectedCorner}, we use this
# model to write that data. This join table is especially useful if you make two
# {Crossing}s at the same intersection.
class DetectedNode < ApplicationRecord
  belongs_to :crossing
  belongs_to :detected_corner
end
