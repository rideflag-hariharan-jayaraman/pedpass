class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :uuid, null: false, index: { unique: true }, comment: <<~CMT
        An MD5 hash of the Device's UUID. This helps prevent multiple signups.
      CMT

      t.string :api_key, null: false

      t.references :user, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
