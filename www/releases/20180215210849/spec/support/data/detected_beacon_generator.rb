class DetectedBeaconGenerator
  attr_reader :intersection, :crosswalk

  def initialize
    @intersection = FactoryBot.create(:intersection)
    @registered_uuid = FactoryBot.create(:ibeacon_uuid)

    corners = FactoryBot.create_list(:corner, 4, intersection: @intersection)
    corners.each do |corner|
      FactoryBot.create(:beacon, corner: corner, ibeacon_uuid: @registered_uuid)
    end

    @crosswalk = Crosswalk.create location: 'Test', corners: intersection.corners.first(2)

  end

  def start
    crosswalk.corners.first
  end

  def target
    crosswalk.corners.second
  end

  def randoms
    intersection.last(2)
  end

  def parsed_data
    {
      detected_beacons: detected_corners,
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude,
      accuracy: rand(35),
      heading: 54.5,
      speed: rand(5),
      device_id: FactoryBot.create(:device).id
    }
  end

  def detected_corners
    @immediates = nil
    @near = nil
    @others = nil

    immediates + near + others
  end

  def immediates
    @immediates ||= start.beacons.first(3).map do |beacon|
      {
        ibeacon_uuid: beacon.ibeacon_uuid.to_s,
        ibeacon_major: beacon.ibeacon_major,
        ibeacon_minor: beacon.ibeacon_minor,
        beacon_proximity: 'IMMEDIATE',
        beacon_battery: rand(99),
        beacon_distance: rand(0.5),
      }
    end
  end

  def near
    @near ||= [start.beacons.last].map do |beacon|
      {
        ibeacon_uuid: beacon.ibeacon_uuid.to_s,
        ibeacon_major: beacon.ibeacon_major,
        ibeacon_minor: beacon.ibeacon_minor,
        beacon_proximity: 'NEAR',
        beacon_battery: rand(99),
        beacon_distance: rand(0.5..2),
      }
    end
  end

  def others
    @others ||= target.beacons.sample(3).map do |beacon|
      {
        ibeacon_uuid: beacon.ibeacon_uuid.to_s,
        ibeacon_major: beacon.ibeacon_major,
        ibeacon_minor: beacon.ibeacon_minor,
        beacon_proximity: 'FAR',
        beacon_battery: rand(99),
        beacon_distance: rand(2..10.999),
      }
    end
  end

  def unregistered_others
    @unregistered ||= target.beacons.sample(3).map do |beacon|
      {

        ibeacon_uuid: "1",
        ibeacon_major: beacon.ibeacon_major,
        ibeacon_minor: beacon.ibeacon_minor,
        beacon_proximity: 'FAR',
        beacon_battery: rand(99),
        beacon_distance: rand(3),
      }
    end
  end
end
