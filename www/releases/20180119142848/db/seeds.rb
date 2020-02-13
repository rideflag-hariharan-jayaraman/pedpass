# Add Settings default values in DB
Setting.beacon_range_near_meters = 3
Setting.crossing_grace_period_seconds = 300
Setting.detected_corner_strategy = 'average'

user = User.create!

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

beacon_nw = Beacon.create!(
  beacon_id: 'jWG7',
  ibeacon_uuid: 'f7826da6-4fa2-4e98-8024-bc5b71e0893e',
  ibeacon_major_number: 48038,
  ibeacon_minor_number: 13722,
  corner_id: north_west_corner.id
)

beacon_ne = Beacon.create!(
  beacon_id: '9HnZ',
  ibeacon_uuid: 'f7826da6-4fa2-4e98-8024-bc5b71e0893e',
  ibeacon_major_number: 44836,
  ibeacon_minor_number: 58103,
  corner_id: north_east_corner.id
)

beacon_sw = Beacon.create!(
  beacon_id: 'KKrz',
  ibeacon_uuid: 'f7826da6-4fa2-4e98-8024-bc5b71e0893e',
  ibeacon_major_number: 45702,
  ibeacon_minor_number: 4528,
  corner_id: south_west_corner.id
)

beacon_se = Beacon.create!(
  beacon_id: 'MnEA',
  ibeacon_uuid: 'f7826da6-4fa2-4e98-8024-bc5b71e0893e',
  ibeacon_major_number: 26555,
  ibeacon_minor_number: 50607,
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

FactoryGirl.create(:detected_corner, device: dummy_device, corner: north_west_corner)
FactoryGirl.create(:detected_corner, device: dummy_device, corner: north_east_corner)

# Create some useful detected corners objects
for corner_id in 1..2
  p corner_id

  10.downto(1) do |distance|
    p distance
    FactoryGirl.create(:detected_corner, device: Device.first, corner_id: corner_id, beacon_distance: distance)
  end

  2.upto(10) do |distance|
    p distance
    FactoryGirl.create(:detected_corner, device: Device.first, corner_id: corner_id, beacon_distance: distance)
  end
end
