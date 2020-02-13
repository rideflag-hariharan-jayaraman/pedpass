class CreateNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :nodes do |t|
      t.references :corner, foreign_key: { on_delete: :cascade }, null: false
      t.references :crosswalk, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
