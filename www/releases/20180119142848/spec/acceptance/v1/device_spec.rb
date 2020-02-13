require 'acceptance_helper'

resource 'Device' do
  header 'Content-Type', 'application/vnd.api+json'

  response_field 'api-key', 'The API key needed to access the API', type: :string

  post '/v1/device' do
    parameter :uuid, 'An MD5 hash of the device\'s UUID.', required: true

    let(:user) { create :user }
    let(:raw_post) do
      {
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
                type: 'users'
              }
            }
          }
        }
      }.to_json
    end

    example_request 'Create a Device' do
      explanation 'Create a new device for a user.'

      expect(status).to eql 201
    end
  end

  get '/v1/device' do
    let(:device) { create :device }

    before { header 'Token', authorization_token(device) }

    example_request 'Show a Device' do
      explanation <<~MSG
        Get information from the current device based on the token provided.
      MSG

      expect(status).to eql 200
    end
  end
end
