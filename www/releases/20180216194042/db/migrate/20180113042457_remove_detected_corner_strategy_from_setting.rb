class RemoveDetectedCornerStrategyFromSetting < ActiveRecord::Migration[5.1]
  def change
    remove_column :settings, :detected_corner_strategy
  end
end
