FactoryBot.define do
  factory :crossing do
    association :crosswalk, factory: :crosswalk_with_corners
    user
    success { true }
    points_earned 1

    before(:create) do |crossing|
      device = create :device, user: crossing.user

      crossing.detected_corners << crossing.crosswalk.corners.map do |corner|
        create :detected_corner, device: device, corner: corner
      end
    end
  end
end
