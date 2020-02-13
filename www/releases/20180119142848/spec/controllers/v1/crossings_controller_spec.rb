describe V1::CrossingsController do
  let(:device) { create :device }
  let!(:crossing) { create :crossing, user: device.user }

  before do
    @request.headers['Content-Type'] = 'application/vnd.api+json'
    authorize_device device
  end

  describe '#index' do
    it 'will list the crossings' do
      get :index
      body = JSON.parse(response.body)['data']

      expect(body.first['id'].to_i).to eql crossing.id
    end

    it 'will have points and score rating in meta' do
      get :index
      meta = JSON.parse(response.body)['meta']

      expect(meta['total-points']).to_not be nil
      expect(meta['success-rating']).to_not be nil
    end


    it 'will return 0 success rating if no crossings' do
      # clear crossings
      device.user.crossings.destroy_all

      get :index, params: { include:'crosswalk,crossing_failure_reason' }

      meta = JSON.parse(response.body)['meta']
      expect(meta['success-rating']).to eq 0.to_s

    end
  end

  describe '#show' do
    it 'will render the crossing' do
      get :show, params: { id: crossing.id }
      body = JSON.parse(response.body)['data']

      expect(body['id'].to_i).to eql crossing.id
    end
  end

  describe '#check_for_success' do
    context 'on success' do
      it 'will respond with an array of crossings' do
        post :check_for_success
        body = JSON.parse(response.body)['data']

        expect(body).to be_a_kind_of(Array)
      end
    end
  end

  describe '#completed' do
    context 'on success' do
      it 'will respond with an array of crossings' do
        post :completed, params: {
          data: {
            type: 'completed',
            attributes: {
              latitude: 43.34433,
              longitude: -80.34343
            }
          }
        }

        body = JSON.parse(response.body)['data']
        expect(body).to be_a_kind_of(Array)
      end

      it 'will have points and score rating in meta' do
        post :completed, params: {
          data: {
            type: 'completed',
            attributes: {
              latitude: 43.34433,
              longitude: -80.34343
            }
          }
        }

        meta = JSON.parse(response.body)['meta']

        expect(meta['total-points']).to_not be nil
        expect(meta['success-rating']).to_not be nil
      end

    end
  end
end
