class CreateBeaconUuids < ActiveRecord::Migration[5.1]
  def change
    create_table :beacon_uuids do |t|
      t.string :uuid

      t.timestamps
    end
  end
end
