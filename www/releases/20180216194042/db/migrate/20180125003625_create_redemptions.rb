class CreateRedemptions < ActiveRecord::Migration[5.1]
  def change
    create_table :redemptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reward, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.integer :points, null: false

      t.timestamps
    end
  end
end
