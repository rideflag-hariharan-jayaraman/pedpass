class DetectedCornerSerializer < ApplicationSerializer
  attributes :beacon_proximity, :beacon_distance, :latitude, :longitude,
             :accuracy, :heading, :speed

  has_many :crossings
  belongs_to :corner
end
