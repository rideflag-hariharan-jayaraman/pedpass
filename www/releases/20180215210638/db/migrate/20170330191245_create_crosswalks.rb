class CreateCrosswalks < ActiveRecord::Migration[5.1]
  def change
    create_table :crosswalks do |t|
      t.string :location

      t.timestamps
    end
  end
end
