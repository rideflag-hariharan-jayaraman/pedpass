class RenameInactiveForRewards < ActiveRecord::Migration[5.1]
  def change
    rename_column :rewards, :inactive, :active
    change_column :rewards, :active, :boolean, default: false, null: false

    add_column :rewards, :starts_at, :datetime
  end
end
