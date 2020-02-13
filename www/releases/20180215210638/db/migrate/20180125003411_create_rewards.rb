class CreateRewards < ActiveRecord::Migration[5.1]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.string :description
      t.integer :points, null: false, default: 1
      t.string :image_url
      t.boolean :inactive, null: false, default: true
      t.datetime :expires_at

      t.timestamps
    end
  end
end
