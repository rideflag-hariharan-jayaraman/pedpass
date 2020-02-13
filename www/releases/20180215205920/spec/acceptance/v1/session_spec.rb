require 'acceptance_helper'

resource 'Session' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/v1/sessions' do
    let(:device) { create(:device, user: create(:user, password: 'password')) }
    let(:raw_post) do
      {
        data: {
          type: 'sessions',
          attributes: {
            email: device.user.email,
            password: 'password',
            device: device.uuid
          }
        }
      }.to_json
    end

    example_request 'Authenticate a User' do
      explanation <<~MSG
        Creates a new api session for a user. It returns the JWT token, whether
        the user has confirmed his e-mail yet or not, and his profile attributes.
        It will register the new device, if it cannot find device for the user.
      MSG

      expect(status).to eql 200
    end
  end

  post '/v1/oauth/facebook' do
    before do
      allow_any_instance_of(Koala::Facebook::API)
      .to receive(:get_object)
      .and_return(JSON.parse({
        email: 'user@example.com', age_range: { min: 20, max: 23 }, gender: 'male'
      }.to_json))
    end

    let(:token) { 'some_random_token' }
    let(:raw_post) do
      {
        auth: { device: 'testdevice123', auth_token: token }
      }.to_json
    end

    example_request 'Authenticate or Create a User using OAuth' do
      explanation <<~MSG
      Authenticates or Creates a new user using OAuth. Currently, we only support facebook.
      The expected url format is `/v1/oauth/:provider`.
      MSG

      expect(status).to eql 200
    end
  end
end
