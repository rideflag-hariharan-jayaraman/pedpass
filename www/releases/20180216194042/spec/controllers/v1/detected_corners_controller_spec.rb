describe V1::DetectedCornersController do
  let(:device) { create :device }
  let(:corner) { create :corner }
  let(:detection) { create :detected_corner, device: device, corner: corner }

  before do
    @request.headers['Content-Type'] = 'application/vnd.api+json'
    authorize_device device
  end

  describe '#index' do
    before { detection }

    it 'will render the detected corners' do
      get :index
      body = JSON.parse(response.body)['data']

      expect(body.first['id'].to_i).to eql detection.id
    end
  end

  describe '#create' do
    context 'on success' do
      before do
        @generator = DetectedBeaconGenerator.new
      end

      it 'will respond with the detected corner' do
        post :create, params: {
          data: {
            type: 'detected-corners',
            attributes: @generator.parsed_data
          }
        }

        body = JSON.parse(response.body)['data']
        meta = JSON.parse(response.body)['meta']

        expect(body['type']).to eql 'detected-corners'
        expect(meta['approaching']).to_not be nil
      end

      skip 'can create with a corner_id' do
        post :create, params: {
          data: {
            type: 'detected-corners',
            attributes: {
              corner_id: corner.id,
              beacon_proximity: 'NEAR',
              beacon_distance: 2.854331,

              latitude: 43.34433,
              longitude: -80.34343,
              accuracy: 12.23,
              heading: 54.5,
              speed: 0.25
            }
          }
        }

        body = JSON.parse(response.body)['data']
        expect(body['type']).to eql 'detected-corners'
      end
    end

    context 'on failure' do
      it 'will respond with an error' do
        post :create, params: {
          data: {
            type: 'detected-corners',
            attributes: {
              device_id: device.id
            }
          }
        }

        body = JSON.parse response.body
        expect(body).to have_key 'errors'
      end
    end
  end

  describe '#show' do
    it 'will render the detected corner' do
      get :show, params: { id: detection.id }
      body = JSON.parse(response.body)['data']

      expect(body['id'].to_i).to eql detection.id
    end
  end
end
