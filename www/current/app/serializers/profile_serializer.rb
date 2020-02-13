class ProfileSerializer < ApplicationSerializer
  attributes :gender, :age_range, :student_id

  belongs_to :user
end
