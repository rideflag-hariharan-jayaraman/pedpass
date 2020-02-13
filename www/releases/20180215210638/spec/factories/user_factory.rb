FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password '12345678'
    password_confirmation { password }

    after(:create) do |user|
      FactoryBot.create(:profile, user: user)
    end

    trait :with_device do
      after(:create) do |user|
        FactoryBot.create(:device, user: user)
      end
    end
  end
end
