class RemoveCrosswalkNullConstraintInCrossings < ActiveRecord::Migration[5.1]
  def up
    change_column :crossings, :crosswalk_id, :bigint, null: true
  end
  def down
    change_column :crossings, :crosswalk_id, :bigint, null: false
  end
end
