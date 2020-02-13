class AddBatteryLifeToBeacons < ActiveRecord::Migration[5.1]
  def change
    add_column :beacons, :battery_life, :integer, null: true
    add_column :beacons, :battery_life_updated_at, :datetime, null: true
  end
end
