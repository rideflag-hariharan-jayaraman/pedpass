class MakeBeaconUuidUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :beacon_uuids, :uuid, unique: true
  end
end
