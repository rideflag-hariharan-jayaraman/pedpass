class AddNameToBeacon < ActiveRecord::Migration[5.1]
  def change
    add_column :beacons, :name, :string, limit: 100
  end
end
