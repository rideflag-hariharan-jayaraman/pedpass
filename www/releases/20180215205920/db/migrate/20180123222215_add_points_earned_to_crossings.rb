class AddPointsEarnedToCrossings < ActiveRecord::Migration[5.1]
  def change
    add_column :crossings, :points_earned, :integer, default: 0 
  end
end
