FactoryGirl.define do
  factory :crosswalk do
    factory :crosswalk_with_corners do
      after(:create) do |crosswalk|
        intersection = create(:intersection, :with_corners)
        crosswalk.corners << intersection.corners
      end
    end
  end
end
