# Add Settings default values in DB
Setting.beacon_range_near_meters = 3
Setting.crossing_grace_period_seconds = 300
Setting.detected_corner_strategy = 'average'
Setting.beacon_update_rate = 1000

user = User.new email: 'user@devbbq.com', password: 'password'
user.skip_confirmation!
user.save

FactoryBot.create(:profile, user: user)

dummy_device = Device.create! do |device|
  device.uuid = Digest::MD5.new.update(SecureRandom.uuid)
  device.user = user
end

# Create CORNERS
intersection = Intersection.create name: 'Test Intersection'
north_west_corner = Corner.create!(
  intersection: intersection,
  location_in_intersection: 'North West',
  latitude: 26.186536,
  longitude: -80.191510
)

north_east_corner = Corner.create!(
  intersection: intersection,
  location_in_intersection: 'North East',
  latitude: 26.186565,
  longitude: -80.191081
)

south_west_corner = Corner.create!(
  intersection: intersection,
  location_in_intersection: 'South West',
  latitude: 26.186153,
  longitude: -80.191520
)

south_east_corner = Corner.create!(
  intersection: intersection,
  location_in_intersection: 'South East',
  latitude: 26.186166,
  longitude: -80.191121
)

# Create BEACONS

ibeacon_uuid = FactoryBot.create(:ibeacon_uuid)
beacon_nw = Beacon.create!(
  name: 'jWG7',
  ibeacon_uuid: ibeacon_uuid,
  ibeacon_major: 48038,
  ibeacon_minor: 13722,
  corner_id: north_west_corner.id
)

beacon_ne = Beacon.create!(
  name: '9HnZ',
  ibeacon_uuid: ibeacon_uuid,
  ibeacon_major: 44836,
  ibeacon_minor: 58103,
  corner_id: north_east_corner.id
)

beacon_sw = Beacon.create!(
  name: 'KKrz',
  ibeacon_uuid: ibeacon_uuid,
  ibeacon_major: 45702,
  ibeacon_minor: 4528,
  corner_id: south_west_corner.id
)

beacon_se = Beacon.create!(
  name: 'MnEA',
  ibeacon_uuid: ibeacon_uuid,
  ibeacon_major: 26555,
  ibeacon_minor: 50607,
  corner_id: south_east_corner.id
)

# Create CROSSWALKS

north_crosswalk = Crosswalk.create!(
  location: 'North',
  corners: [north_east_corner, north_west_corner]
)

east_crosswalk = Crosswalk.create!(
  location: 'East',
  corners: [north_east_corner, south_east_corner]
)

west_crosswalk = Crosswalk.create!(
  location: 'West',
  corners: [north_west_corner, south_west_corner]
)

south_crosswalk = Crosswalk.create!(
  location: 'South',
  corners: [south_east_corner, south_west_corner]
)

FactoryBot.create(:detected_corner, device: dummy_device, corner: north_west_corner)
FactoryBot.create(:detected_corner, device: dummy_device, corner: north_east_corner)

# Create some useful detected corners objects
for corner_id in 1..2
  p corner_id

  10.downto(1) do |distance|
    p distance
    FactoryBot.create(:detected_corner, device: Device.first, corner_id: corner_id, beacon_distance: distance)
  end

  2.upto(10) do |distance|
    p distance
    FactoryBot.create(:detected_corner, device: Device.first, corner_id: corner_id, beacon_distance: distance)
  end
end
