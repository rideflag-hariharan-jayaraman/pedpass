require 'acceptance_helper'

resource 'Crossings' do
  let(:device) { create :device }
  let!(:crossing) { create :crossing, user: device.user }

  header 'Content-Type', 'application/vnd.api+json'

  latitude = "The recorded device latitude at the time of 'trip completion'."
  response_field :latitude, latitude, type: :decimal

  longitude = "The recorded device longitude at the time of 'trip completion'."
  response_field :longitude, longitude, type: :decimal

  response_field 'success', 'Whether or not a crossing is considered successful.', type: :boolean

  before { header 'Authorization', authorization_token(device) }

  get '/v1/crossings' do
    example_request 'List all Crossings' do
      explanation <<~MSG
        List all crossings per device. To include the Crosswalk and CrossingFailureReason data,
        you will need to use `?include=crosswalk`; [Inclusion of Related
        Resources](http://jsonapi.org/format/#fetching-includes).
      MSG

      expect(status).to eql 200
    end
  end

  get '/v1/crossings/:id' do
    let(:id) { crossing.id }

    example_request 'Show a Crossing' do
      explanation <<~MSG
        Get information for a single crossing. To include the Crosswalk and CrossingFailureReason data,
        you will need to use `?include=crosswalk`; [Inclusion of Related
        Resources](http://jsonapi.org/format/#fetching-includes).
      MSG

      expect(status).to eql 200
    end
  end

  post '/v1/crossings/check_for_success' do
    example_request 'Check for Successful Crossing' do
      explanation <<~MSG
        Attempt to process all outstanding DetectedCorner data at any point during a 'trip'.
        The response will contain an array of Crossings if one or more Successful Crossings
        were detected in recent DetectedCorner data. All previous DetectedCorner data will
        be processed up to this point in time.
      MSG

      expect(status).to eql 200
    end
  end

  post '/v1/crossings/completed' do
    let(:raw_post) do
      {
        data: {
          type: 'completed',
          attributes: {
            latitude: 43.34433,
            longitude: -80.34343
          }
        }
      }.to_json
    end

    parameter :latitude, latitude, required: true
    parameter :longitude, longitude, required: true

    example_request 'Complete a Crossing trip' do
      explanation <<~MSG
        Record when no new Corners have been detected for some period of time.
        Marks the end of a recent trip and returns a list of Crossings if found.
        The response will contain an array of Crossings if one or more were detected in recent
        DetectedCorner data. To include the Crosswalk and CrossingFailureReason data,
        you will need to use `?include=crosswalk`; [Inclusion of Related
        Resources](http://jsonapi.org/format/#fetching-includes).
      MSG

      expect(status).to eql 200
    end
  end

end
