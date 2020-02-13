FactoryBot.define do
  factory :beacon do
    name { "#{Faker::Address.street_address}_BEACON_#{rand(99)}" }
    battery_life { (0..100).to_a.sample }
    battery_life_updated_at DateTime.now
    ibeacon_major { (1_000..99_999).to_a.sample }
    ibeacon_minor { (1_000..99_999).to_a.sample }

    corner
    ibeacon_uuid
  end
end
