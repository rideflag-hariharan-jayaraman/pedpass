# PLEASE USE ONLY WITH TESTS
class IntersectionSimulator
  # @param {corner_data_path} file path of json export of corners from rails admin to examin
  def initialize(corner_data_path)
    @corner_file_path = corner_data_path
  end

  # Create Intersection, Corners, Crosswalk, and Beacons
  def setup
    intersections, corners, beacons, crosswalks = [], [], [], []

    # Gather Intersections
    intersections.concat gather_intersections
    # Gather Corners
    corners.concat gather_corners
    # Gather Beacons
    beacons.concat gather_beacons
    # Gather Crosswalks
    crosswalks.concat gather_crosswalks


    intersections.each { |data| Intersection.create data }
    corners.each { |data| Corner.create data }
    beacons.each { |data| Beacon.create data }
    crosswalks.each { |data| Crosswalk.create data }

    load_crossing_failure_reason
    load_settings
  end

  # @param {path} file path of json export of beacon_data from rails admin to examin
  def evaluate(path)
    data = beacon_data path
    detected_corners = {}

    device = FactoryBot.create(:device)

    # CLEAN DATA
    DetectedBeacon.destroy_all
    DetectedCorner.destroy_all
    Crossing.destroy_all


    data.each do |beacon|
      detected_corner = beacon['detected_corner']
      detected_corners[detected_corner['id']] ||= {
        detected_beacons: [],
        device_id: device.id,
      }.merge(
        detected_corner.slice('longitude', 'latitude', 'speed', 'accuracy', 'heading')
      )

      detected_corners[detected_corner['id']][:detected_beacons] << transform_beacon(beacon)
    end
    detected_corners.to_a.sort_by { |e| e[0].to_s.to_i }.map { |e| e[1] }.each do |params|
      batch = BeaconBatch::Base.new params
      detected_corner = batch.process

      raise 'DETECTED CORNER NOT SAVED' unless detected_corner.persisted?

      successful_crossing?(device) if detected_corner.near_corner?
    end

    # complete_trip(device) if DetectedCorner.where(processed: false).count > 0

    # ALL CROSSINGS
    device.user.crossings.order("created_at DESC")
  end

  private
  ## GATHERS
  def gather_intersections
    corner_data.map { |c| c['intersection'] }.uniq { |i| i['id'] }
  end

  def gather_corners
    corner_data.map do |c|
      c.slice(
        'id', 'location_in_intersection', 'latitude', 'longitude', 'created_at',
        'updated_at', 'near_limit', 'approaching_limit'
      ).merge intersection_id: c['intersection']['id']
    end.uniq { |i| i['id'] }
  end

  def gather_beacons
    corner_data.map do |c|
      c['beacons'].map do |b|
        b.merge(ibeacon_uuid_id: universal_uuid.id, corner_id: c['id'])
      end
    end.flatten
  end

  def gather_crosswalks
    corner_data.reduce({}) do |crosswalks, c|
      ## split corner ids into crosswalk partions
      c['crosswalks'].each do |cw|
        crosswalks[cw['id']] ||= cw.merge corner_ids: []
        crosswalks[cw['id']][:corner_ids] << c['id']
      end

      crosswalks
    end.values
  end

  def transform_beacon(beacon)
    {
      'beacon_proximity': beacon['beacon_proximity'],
      'ibeacon_uuid': universal_uuid.uuid,
      'ibeacon_major': beacon['beacon']['ibeacon_major'],
      'ibeacon_minor': beacon['beacon']['ibeacon_minor'],
      'beacon_battery': beacon['beacon_battery'],
      'beacon_distance': beacon['beacon_distance'],
    }
  end

  def universal_uuid
    @beacon_uuid ||= FactoryBot.create(:ibeacon_uuid)
  end

  def successful_crossing?(device)
    # Look at the currently unprocessed data to find any Successful crossings
    options = {
      current_user: device.user,
      device_id: device.id,
      trip_is_complete: false
    }

    Crossing.process_detected_corner_data(options)
  end

  def complete_trip(device)
    options = {
      current_user: device.user,
      device_id: device.id,
      trip_is_complete: true,
      coordinates: {
        latitude: Faker::Address.latitude,
        longitude: Faker::Address.longitude,
      }
    }

    Crossing.process_detected_corner_data(options)
  end


  ## DATA SETS
  def corner_data
    @corner_data ||= JSON.parse(
      File.read(@corner_file_path)
    )
  end

  def beacon_data(path)
    JSON.parse File.read(path)
  end

  def load_crossing_failure_reason
    [
      {
        "description":"Far from A, Far from B",
        "failure_code":"far_far",
        "failure_reason":"Not close enough to both corners"
      },
      {
        "description":"Far from A, Near B",
        "failure_code":"far_near",
        "failure_reason":"Not close enough to the first corner"
      },
      {
        "description":"Near A, Far from B",
        "failure_code":"near_far",
        "failure_reason":"Not close enough to the second corner"
      },
      {
        "description":"Invalid Crosswalk",
        "failure_code":"invalid_crosswalk",
        "failure_reason":"Crossing was not a valid crosswalk"
      }
    ].each { |params|  CrossingFailureReason.create! params }
  end

  def load_settings
    Setting.create!(var: 'beacon_range_near_meters', value: 3)
    Setting.create!(var: 'crossing_grace_period_seconds', value: 300)
    Setting.create!(var: 'detected_corner_strategy', value: 'average')
  end
end
