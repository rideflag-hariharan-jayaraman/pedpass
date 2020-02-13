class AddProcessAtToDetectedCorners < ActiveRecord::Migration[5.1]
  def change
    add_column :detected_corners, :processed, :boolean, default: false
  end
end
