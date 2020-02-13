class DetectedBeacon < ApplicationRecord
  belongs_to :detected_corner
  belongs_to :beacon

  validates :detected_corner, :beacon, presence: true

  after_create -> { beacon.update_columns(battery_life: beacon_battery, battery_life_updated_at: DateTime.current) if beacon.update_battery_life? }
end
