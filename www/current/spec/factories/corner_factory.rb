FactoryBot.define do
  factory :corner do
    latitude { rand(26.000001..26.999999) }
    longitude { -rand(80.000001..80.999999) }
    intersection { create(:intersection) }

    near_limit { rand(1..4).to_i }
    approaching_limit { rand(4..10).to_i }

    after(:create) do |corner|
      create_list :beacon, 4, corner: corner
    end
  end
end
