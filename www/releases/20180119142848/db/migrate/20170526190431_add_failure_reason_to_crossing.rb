class AddFailureReasonToCrossing < ActiveRecord::Migration[5.1]
  def change
    add_column :crossings, :crossing_failure_reason_id, :integer
  end
end
