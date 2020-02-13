class CreateDetectedBeacons < ActiveRecord::Migration[5.1]
  def change
    create_table :detected_beacons do |t|
      t.references :detected_corner, foreign_key: true
      t.references :beacon, foreign_key: true
      t.string :beacon_proximity, null: false
      t.decimal :beacon_distance, precision: 10, scale: 7, null: false

      t.timestamps
    end
  end
end
