class CreateIntersections < ActiveRecord::Migration[5.1]
  def change
    create_table :intersections do |t|
      t.string :name

      t.timestamps
    end
  end
end
