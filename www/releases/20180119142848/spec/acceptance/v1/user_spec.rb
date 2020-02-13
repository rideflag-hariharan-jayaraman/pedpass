require 'acceptance_helper'

resource 'User' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/v1/user' do
    let(:raw_post) do
      {
        device_token: 'direwolf',
        data: {
          type: 'users',
          attributes: {
            devices_attributes: [
              {
                uuid: 'c9533eb0b2906df55feb2cf82a23f35e'
              }
            ]
          }
        }
      }.to_json
    end

    example_request 'Create a User' do
      explanation <<~MSG
        Creates a new user. You can also use this endpoint as well to create a
        device simultaneously upon registration. You can also use this endpoint
        to lookup the user as well via a UUID.
      MSG

      expect(status).to eql 201
    end
  end

  get '/v1/user' do
    let(:device) { create :device }

    before { header 'Token', authorization_token(device) }

    example_request 'Show a User' do
      explanation 'View a user.'

      expect(status).to eql 200
    end
  end
end
