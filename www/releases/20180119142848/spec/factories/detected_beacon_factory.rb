FactoryGirl.define do
  factory :detected_beacon do
    beacon_proximity { %w[NEAR FAR IMMEDIATE UNKNOWN].sample }
    beacon_distance { rand(0.000001..9.999999) }
    beacon_battery { rand(99) }

    detected_corner
    beacon
  end
end
