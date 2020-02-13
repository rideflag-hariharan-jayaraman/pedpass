class ChangeCrossingFailureToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :crossings, :message, :string, limit: 20

    # Convert all Crossings Failure reason to message
    Crossing.all.each do |crossing|
      if crossing.crossing_failure_reason.present?
        crossing.update(message: crossing.crossing_failure_reason.failure_code)
      end
    end

    remove_column :crossings, :crossing_failure_reason_id
  end
end
