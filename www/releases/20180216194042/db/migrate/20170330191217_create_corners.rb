class CreateCorners < ActiveRecord::Migration[5.1]
  def change
    create_table :corners do |t|
      t.string :beacon_id, null: false, index: true, comment: <<~CMT.squish
        The beacon_id is simply an alias to the ibeacon_uuid. It's only four
        characters and it would be easy to create id collisions here. Treat this
        as a simple "nickname", nothing more.
      CMT

      t.string :ibeacon_uuid, null: false, comment: <<~CMT.squish
        Not an actual UUID as this is the same for all beacons in a package.
        They are differentiated based on the major and minor number.
      CMT

      t.integer :ibeacon_major_number, null: false
      t.integer :ibeacon_minor_number, null: false

      t.string :location_in_intersection

      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false

      t.index [:latitude, :longitude], unique: true

      t.timestamps
    end
  end
end
