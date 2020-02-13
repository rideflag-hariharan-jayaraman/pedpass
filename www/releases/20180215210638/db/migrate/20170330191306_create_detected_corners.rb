class CreateDetectedCorners < ActiveRecord::Migration[5.1]
  def change
    create_table :detected_corners do |t|
      t.string :beacon_proximity, null: false
      t.decimal :beacon_distance, precision: 10, scale: 7, null: false

      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false

      t.decimal :accuracy, precision: 6, scale: 3, null: false
      t.decimal :heading, precision: 6, scale: 3, null: false
      t.decimal :speed, precision: 6, scale: 3, null: false

      t.references :corner, foreign_key: { on_delete: :cascade }, null: false
      t.references :device, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
