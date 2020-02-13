class RenameFieldsAndModel < ActiveRecord::Migration[5.1]
  def change
    remove_column :beacons, :beacon_uuid_id

    rename_table :beacon_uuids, :ibeacon_uuids
    add_reference :beacons, :ibeacon_uuid, foreign_key: true

    rename_column :beacons, :ibeacon_major_number, :ibeacon_major
    rename_column :beacons, :ibeacon_minor_number, :ibeacon_minor
  end
end
