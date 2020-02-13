class AddFieldsToIntersections < ActiveRecord::Migration[5.1]
  def change
      add_column :intersections, :latitude, :decimal, precision: 10, scale: 6
      add_column :intersections, :longitude, :decimal, precision: 10, scale: 6
      add_column :intersections, :description, :string
      add_column :intersections, :throttle_points_delay_minutes, :integer, default: 60

      add_index :intersections, [:latitude, :longitude], unique: true
  end
end
