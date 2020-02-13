class AddSuccessToCrossing < ActiveRecord::Migration[5.1]
  def change
    add_column :crossings, :success, :boolean, null: false
  end
end
