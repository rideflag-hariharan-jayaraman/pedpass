class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.string :provider, null: false
      t.string :uid, null: false

      t.references :user, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
