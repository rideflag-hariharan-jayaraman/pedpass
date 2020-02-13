FactoryGirl.define do
  factory :crossing do
    association :crosswalk, factory: :crosswalk_with_corners
    user
    success { true }
    sub_user_id { user_id }

    before(:create) do |crossing|
      device = create :device, user: crossing.user

      crossing.detected_corners << crossing.crosswalk.corners.map do |corner|
        create :detected_corner, device: device, corner: corner
      end
    end
  end
end
