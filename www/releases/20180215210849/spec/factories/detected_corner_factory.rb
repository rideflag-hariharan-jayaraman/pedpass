FactoryBot.define do
  factory :detected_corner do
    beacon_proximity { %w[NEAR FAR IMMEDIATE UNKNOWN].sample }
    beacon_distance { rand(0.000001..9.999999) }

    latitude { rand(26.000001..26.999999) }
    longitude { -rand(80.000001..80.999999) }

    accuracy { rand(0.01..100.00) }
    heading { rand(0.01..359.99) }
    speed { rand(0.25..7.5) }

    corner
    device
  end
end
