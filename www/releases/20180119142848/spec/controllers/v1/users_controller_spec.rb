describe V1::UsersController do
  before do
    @request.headers['Content-Type'] = 'application/vnd.api+json'
  end

  describe '#create' do
    context 'on success' do
      it 'will create the user' do
        post :create, params: {
          device_token: Rails.application.secrets.device_registration_token,
          data: {
            type: 'users',
            attributes: {
              devices_attributes: [
                {
                  uuid: 'hello'
                }
              ]
            }
          }
        }

        expect(response).to have_http_status 201

        data = JSON.parse(response.body)['data']
        expect(data['type']).to eql 'users'

        expect(Device.count).to eql 1
      end
    end

    context 'on failure' do
      it 'will respond with an error' do
        allow_any_instance_of(User).to receive(:persisted?) { false }

        post :create, params: {
          device_token: Rails.application.secrets.device_registration_token,
          data: {
            type: 'users',
            attributes: { foo: 'bar' }
          }
        }

        expect(response).to have_http_status 422
      end
    end

    context 'when the device UUID already exists' do
      let!(:device) { create :device }

      it 'will render the user of that device' do
        expect(User.count).to eql 1

        post :create, params: {
          device_token: Rails.application.secrets.device_registration_token,
          data: {
            type: 'users',
            attributes: {
              devices_attributes: [
                {
                  uuid: device.uuid
                }
              ]
            }
          }
        }

        expect(User.count).to eql 1
        expect(response).to have_http_status 200
      end
    end
  end

  describe '#show' do
    let(:device) { create :device }

    it 'will render the current user' do
      authorize_device device
      get :show

      data = JSON.parse(response.body)['data']
      expect(data['id'].to_i).to eql device.user_id
    end
  end
end
