class CreateDetectedNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :detected_nodes do |t|
      t.references :detected_corner, foreign_key: { on_delete: :cascade }, null: false
      t.references :crossing, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
