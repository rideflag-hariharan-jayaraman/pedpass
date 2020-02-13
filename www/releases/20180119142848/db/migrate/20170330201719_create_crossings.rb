class CreateCrossings < ActiveRecord::Migration[5.1]
  def change
    create_table :crossings do |t|
      t.references :crosswalk, foreign_key: { on_delete: :cascade }, null: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
