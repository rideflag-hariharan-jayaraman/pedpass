describe V1::UsersController do
  before do
    @request.headers['Content-Type'] = 'application/vnd.api+json'
  end

  describe '#create' do
    let(:user) { build(:user) }
    let(:attributes_params) do
      {
        email: user.email,
        password: user.password,
        profile_attributes: {
          age_range: AgeRange.sample.to_s,
          gender: Gender.sample.to_s,
          student_id: '2131',
        },
        devices_attributes: [
          {
            uuid: 'hello'
          }
        ]
      }
    end

    context 'on success' do
      it 'will create the user' do
        post :create, params: {
          device_token: Rails.application.secrets.device_registration_token,
          data: {
            type: 'users',
            attributes: attributes_params
          }
        }


        expect(response).to have_http_status 201

        data = JSON.parse(response.body)['data']
        expect(data['type']).to eql 'users'

        expect(Device.count).to eql 1
        expect(Profile.count).to eql 1
      end
    end

    context 'on failure' do
      it 'will respond with an error' do
        allow_any_instance_of(User).to receive(:persisted?) { false }

        post :create, params: {
          device_token: Rails.application.secrets.device_registration_token,
          data: {
            type: 'users',
            attributes: {
              email: 'test@example.com',
              password: 'password',
            }
          }
        }

        expect(response).to have_http_status 422
      end
    end

    context 'invalid enum values for age range or gender' do
      it 'will respond with an error' do
        post :create, params: {
          device_token: Rails.application.secrets.device_registration_token,
          data: {
            type: 'users',
            attributes: attributes_params.merge(
              profile_attributes: { age_range: '15', gender: Gender.sample }
            )
          }
        }

        expect(response).to have_http_status 422
        error_key = JSON.parse(response.body)['errors'][0]['source']['pointer']
        expect(error_key).to include 'age-range'
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

  describe '#update' do
    let(:device) { create(:device) }
    let(:attributes_params) do
      {
        email: '123456james@gmail.com',
        profile_attributes: {
          age_range: AgeRange.sample.to_s,
          gender: Gender.sample.to_s,
          student_id: '12131',
        }
      }
    end

    before do
      @request.headers['Authorization'] = authorize_device(device)
    end

    context 'on success' do
      it 'will update the user' do
        patch :update, params: {
          data: {
            type: 'users',
            attributes: attributes_params
          }
        }


        expect(response).to have_http_status 200

        data = JSON.parse(response.body)['data']
        expect(data['type']).to eql 'users'
      end
    end

    context 'on failure' do
      it 'will respond with an error' do
        allow_any_instance_of(User).to receive(:persisted?) { false }

        patch :update, params: {
          data: {
            type: 'users',
            attributes: { email: '' }
          }
        }

        expect(response).to have_http_status 422
      end
    end

  end
end
