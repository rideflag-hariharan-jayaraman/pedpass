# When a {Device} comes in range of a {Corner}, we log it here. Then we use an
# algorithm to detect if this could be the finalization of a {Crossing}.
class DetectedCorner < ApplicationRecord
  has_many :detected_nodes
  has_many :detected_beacons, dependent: :destroy
  has_many :crossings, through: :detected_nodes

  belongs_to :device
  belongs_to :corner

  has_many :nodes, through: :corner

  validates :beacon_proximity, :beacon_distance, :latitude, :longitude, :speed,
            :heading, :accuracy, presence: true

  def near_corner?
    corner.present? && beacon_distance <= corner.near_limit
  end

  def approaching_corner?
    corner.present? && beacon_distance <= corner.approaching_limit
  end
end
