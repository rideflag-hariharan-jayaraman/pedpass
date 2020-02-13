class CreateBeacons < ActiveRecord::Migration[5.1]
  BEACON_COLUMNS = %i[
    beacon_id ibeacon_uuid ibeacon_major_number ibeacon_minor_number
  ].freeze

  def up
    create_table :beacons do |t|
      t.string :beacon_id, null: false, index: true, comment: <<~CMT.squish
        The beacon_id is simply a short id or alias to the ibeacon_uuid. It's
        only four characters.
      CMT

      t.string :ibeacon_uuid, null: false, comment: <<~CMT.squish
        Not an actual UUID as this is the same for all beacons in a package.
        They are differentiated based on the major and minor number.
      CMT

      t.integer :ibeacon_major_number, null: false
      t.integer :ibeacon_minor_number, null: false

      t.references :corner, foreign_key: true

      t.timestamps
    end

    Corner.select(*[:id, *BEACON_COLUMNS]).find_each do |corner|
      corner.create_beacon!(corner.attributes)
    end

    BEACON_COLUMNS.each do |column|
      remove_column :corners, column
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
