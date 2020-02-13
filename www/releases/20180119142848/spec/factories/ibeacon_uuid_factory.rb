FactoryGirl.define do
  factory :ibeacon_uuid do
    uuid { SecureRandom.uuid }
  end
end
