FactoryBot.define do
  factory :intersection do
    name { Faker::Address.street_address }

    trait :with_corners do
      transient do
        corner_count 2
      end

      after(:create) do |intersection, evaluator|
        FactoryBot.create_list(:corner, evaluator.corner_count, {
          intersection: intersection,
        })
      end
    end
  end
end
