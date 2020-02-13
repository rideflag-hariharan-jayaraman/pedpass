class AddStrategyToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :detected_corner_strategy, :string
  end
end
