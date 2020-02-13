class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true
      t.string :gender, null: false, limit: 10
      t.string :age_range, null: false, limit: 8
      t.string :student_id, null: true, limit: 20

      t.timestamps
    end
  end
end
