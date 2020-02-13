class AddIntersectionIdToCorner < ActiveRecord::Migration[5.1]
  def change
    add_reference :corners, :intersection, foreign_key: true
  end
end
