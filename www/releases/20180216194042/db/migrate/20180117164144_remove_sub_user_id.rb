class RemoveSubUserId < ActiveRecord::Migration[5.1]
  def change
    remove_column :detected_corners, :sub_user_id
    remove_column :crossings, :sub_user_id
  end
end
