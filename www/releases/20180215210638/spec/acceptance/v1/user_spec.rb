require 'acceptance_helper'

resource 'User' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/v1/user' do
    let(:user) { build(:user) }
    let(:raw_post) do
      {
        device_token: 'direwolf',
        data: {
          type: 'users',
          attributes: {
            email: user.email,
            password: 'password',
            profile_attributes: {
              gender: Gender.sample,
              age_range: AgeRange.sample,
              student_id: '111111'
            },
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
        device simultaneously upon registration.
      MSG

      expect(status).to eql 201
    end
  end

  patch '/v1/user' do
    let(:device) { create(:device, user: create(:user)) }

    before { header 'Authorization', authorization_token(device) }

    let(:raw_post) do
      {
        data: {
          type: 'users',
          attributes: {
            profile_attributes: {
              gender: Gender.sample,
              age_range: AgeRange.sample,
              student_id: '1111112'
            },
          }
        }
      }.to_json
    end

    example_request 'Update a User' do
      explanation <<~MSG
      Updates the authenticated user.
      MSG

      expect(status).to eql 200
    end
  end


  get '/v1/user' do
    let(:device) { create :device }

    before { header 'Authorization', authorization_token(device) }

    example_request 'Show a User' do
      explanation 'View a user.'

      expect(status).to eql 200
    end
  end
end
