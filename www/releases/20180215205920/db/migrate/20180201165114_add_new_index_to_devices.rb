class AddNewIndexToDevices < ActiveRecord::Migration[5.1]
  def change
    remove_index :devices, :uuid
    add_index :devices, [:user_id, :uuid], unique: true
  end
end
