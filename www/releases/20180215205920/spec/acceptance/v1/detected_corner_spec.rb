require 'acceptance_helper'

resource 'Detected Corner' do
  let(:device) { create :device }

  header 'Content-Type', 'application/vnd.api+json'

  before { header 'Authorization', authorization_token(device) }

  beacon_proximity = 'A description of how far or close the device is to the beacon.'
  response_field 'beacon-proximity', beacon_proximity, type: :string

  beacon_distance = 'The distance of the device from the beacon (measured in meters).'
  response_field 'beacon-distance', beacon_distance, type: :decimal

  beacon_battery_life = 'The current battery life in percent (i.e. 97%).'
  response_field 'beacon-battery', beacon_battery_life, type: :integer

  latitude = 'The recorded device latitude at the time of detection.'
  response_field :latitude, latitude, type: :decimal

  longitude = 'The recorded device longitude at the time of detection.'
  response_field :longitude, longitude, type: :decimal

  accuracy = 'How accurate the GPS believes to be.'
  response_field :accuracy, accuracy, type: :decimal

  heading = 'The heading/direction of the device when in motion (degrees).'
  response_field :heading, heading, type: :decimal

  speed = 'The speed of the device when in motion (measured in m/s).'
  response_field :speed, speed, type: :decimal

  get '/v1/detected_corners' do
    before { create :detected_corner, device: device }

    example_request 'List all Detected Corners' do
      explanation 'List all detected corners per device.'

      expect(status).to eql 200
    end
  end

  post '/v1/detected_corners' do
    let(:beacons) { create_list(:beacon, 3) }

    let(:raw_post) do
      {
        data: {
          type: 'detected-corners',
          attributes: {
            "detected-beacons": [
              {
                "beacon-proximity": "IMMEDIATE",
                "ibeacon-uuid": beacons.first.ibeacon_uuid.to_s,
                "ibeacon-major": beacons.first.ibeacon_major,
                "ibeacon-minor": beacons.first.ibeacon_minor,
                "beacon-battery": 80,
                "beacon-distance": 0.29712315285660296
              },
              {
                "beacon-proximity": "NEAR",
                "ibeacon-uuid": beacons.second.ibeacon_uuid.to_s,
                "ibeacon-major": beacons.second.ibeacon_major,
                "ibeacon-minor": beacons.second.ibeacon_minor,
                "beacon-battery": 77,
                "beacon-distance": 0.7483568304270122
              },
              {
                "beacon-proximity": "NEAR",
                "ibeacon-uuid": beacons.third.ibeacon_uuid.to_s,
                "ibeacon-major": beacons.third.ibeacon_major,
                "ibeacon-minor": beacons.third.ibeacon_minor,
                "beacon-battery": 58,
                "beacon-distance": 1.22901652791358
              }
            ],
            "longitude": -80.48511271,
            "latitude": 43.48835487,
            "speed": 0,
            "accuracy": 43,
            "heading": 0
          }
        }
      }.to_json
    end

    parameter 'ibeacon-uuid', 'The uuid of the beacon provided from the hardware.', required: true
    parameter 'ibeacon-major', 'The major proximity id of the beacon provided from the hardware.', required: true
    parameter 'ibeacon-minor', 'The minor proximity id of the beacon provided from the hardware.', required: true
    parameter 'beacon-proximity', beacon_proximity, required: true
    parameter 'beacon-distance', beacon_distance, required: true
    parameter :latitude, latitude, required: true
    parameter :longitude, longitude, required: true
    parameter :accuracy, accuracy, required: true
    parameter :heading, heading, required: true
    parameter :speed, speed, required: true
    parameter 'beacon-battery', beacon_battery_life
    parameter 'corner-id', 'The ID of the corner detected.'

    example_request 'Create a Detected Corner' do
      explanation <<~MSG
        Record when a corner has been detected for a device. Please send all of
        the data required. You must supply either a `beacon-id` or a
        `corner-id`. If you'd like to include the crossings or corner from a detection,
        you will need to use `?include=crossings,corner`; [Inclusion of Related
        Resources](http://jsonapi.org/format/#fetching-includes).
      MSG

      expect(status).to eql 201
    end
  end

  get '/v1/detected_corners/:id' do
    let(:detected_corner) { create :detected_corner, device: device }
    let(:id) { detected_corner.id }

    example_request 'Show a Detected Corner' do
      explanation 'Get information for a single detected corner.'

      expect(status).to eql 200
    end
  end
end
