class Beacon < ApplicationRecord
  belongs_to :corner
  belongs_to :ibeacon_uuid


  validates :beacon_id, presence: true, uniqueness: true, allow_nil: false
  validates :name, :ibeacon_uuid, :ibeacon_major, :ibeacon_minor, presence: true

  before_validation :set_beacon_id

  ## --------------------------- METHODS ---------------------------
  def update_battery_life?
    battery_life_updated_at.blank? || (battery_life_updated_at < (DateTime.current - 1.day))
  end

  def to_s
    name
  end

  private
  def set_beacon_id
    # It represents unique beacon that is registered for the platform
    # using the combination of major + minor proximity
    self.beacon_id = "#{ibeacon_major}_#{ibeacon_minor}"
  end
end
