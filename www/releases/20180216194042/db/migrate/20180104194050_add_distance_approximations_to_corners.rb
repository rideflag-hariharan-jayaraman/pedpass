class AddDistanceApproximationsToCorners < ActiveRecord::Migration[5.1]
  def change
    add_column :corners, :near_limit, :integer, default: 2
    add_column :corners, :approaching_limit, :integer, default: 4

    Corner.update_all(near_limit: 2, approaching_limit: 4)
  end
end
