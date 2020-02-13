class AddBeaconUuidToBeacon < ActiveRecord::Migration[5.1]
  def change
    remove_column :beacons, :ibeacon_uuid
    add_reference :beacons, :beacon_uuid, foreign_key: true
  end
end
