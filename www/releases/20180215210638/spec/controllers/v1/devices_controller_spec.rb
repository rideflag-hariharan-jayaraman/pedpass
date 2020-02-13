describe V1::DevicesController do
  before do
    @request.headers['Content-Type'] = 'application/vnd.api+json'
  end

  describe '#create' do
    let(:user) { create :user }

    context 'on success' do
      it 'will respond with the device data' do
        post :create, params: {
          device_token: 'direwolf',
          data: {
            type: 'devices',
            attributes: {
              uuid: 'c9533eb0b2906df55feb2cf82a23f35e'
            },
            relationships: {
              user: {
                data: {
                  id: user.id,
                  type: "users"
                }
              }
            }
          }
        }

        expect(response).to have_http_status 201
      end
    end

    context 'on failure' do
      it 'will respond with an error' do
        post :create, params: {
          device_token: 'direwolf',
          data: {
            type: 'devices',
            attributes: {
              uuid: 'c9533eb0b2906df55feb2cf82a23f35e'
            }
          }
        }

        expect(response).to have_http_status 422
      end
    end

    context 'when unauthorize' do
      it 'will respond with an error' do
        post :create, params: {}

        expect(response).to have_http_status 401
      end
    end
  end

  describe '#show' do
    let(:device) { create :device }

    it 'will render the current device' do
      authorize_device device
      get :show

      data = JSON.parse(response.body)['data']
      expect(data['id'].to_i).to eql device.id
    end

    context 'when unauthorized' do
      it 'will render an error' do
        get :show

        errors = JSON.parse(response.body)['errors']
        expect(errors.first['title']).to eql 'Unauthorized'
        expect(response).to have_http_status 401
      end
    end
  end
end
