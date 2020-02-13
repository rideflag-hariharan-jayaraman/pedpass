class AddBeaconBatteryToDetectedBeacons < ActiveRecord::Migration[5.1]
  def change
    add_column :detected_beacons, :beacon_battery, :integer, null: true
  end
end
