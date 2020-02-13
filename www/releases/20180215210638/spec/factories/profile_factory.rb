FactoryBot.define do
  factory :profile do
    gender { Gender.sample }
    age_range { AgeRange.sample }
    student_id '111111'

    user
  end
end
