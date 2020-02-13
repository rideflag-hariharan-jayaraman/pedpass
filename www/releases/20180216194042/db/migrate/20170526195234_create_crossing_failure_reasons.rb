class CreateCrossingFailureReasons < ActiveRecord::Migration[5.1]
  def up
    create_table :crossing_failure_reasons do |t|
      t.string :description, null: false
      t.string :failure_code, null: false
      t.string :failure_reason, null: false

      t.timestamps
    end

    CrossingFailureReason.create!(description: 'Invalid Crosswalk', failure_code: 'invalid_crosswalk', failure_reason: 'Crossing was not a valid crosswalk')
    CrossingFailureReason.create!(description: 'Near A, Far from B', failure_code: 'near_far', failure_reason: 'Not close enough to the second corner')
    CrossingFailureReason.create!(description: 'Far from A, Near B', failure_code: 'far_near', failure_reason: 'Not close enough to the first corner')
    CrossingFailureReason.create!(description: 'Far from A, Far from B', failure_code: 'far_far', failure_reason: 'Not close enough to both corners')
  end

  def down
    drop_table :crossing_failure_reasons
  end
end
