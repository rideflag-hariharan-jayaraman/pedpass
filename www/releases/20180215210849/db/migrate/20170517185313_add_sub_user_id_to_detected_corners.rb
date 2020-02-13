class AddSubUserIdToDetectedCorners < ActiveRecord::Migration[5.1]
  def change
    add_column :detected_corners, :sub_user_id, :integer, null: false, default: 1
    add_index :detected_corners, %i(device_id sub_user_id), unique: false
  end
end
