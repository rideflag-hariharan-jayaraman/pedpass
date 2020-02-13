class AddSubUserIdToCrossings < ActiveRecord::Migration[5.1]
  def change
    add_column :crossings, :sub_user_id, :integer, null: false, default: 1
    add_index :crossings, %i(user_id sub_user_id), unique: false
  end
end
