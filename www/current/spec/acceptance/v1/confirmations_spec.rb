require 'acceptance_helper'

resource 'Confirmations' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/v1/confirmations' do
    let(:user) { create(:user) }
    let(:raw_post) do
      {
        data: {
          type: 'confirmations',
          attributes: {
            email: user.email,
          }
        }
      }.to_json
    end

    example_request 'Resend Confirmation Instructions' do
      explanation <<~MSG
        Sends a confirmation link to the user's email.
      MSG

      expect(status).to eql 200
    end
  end
end
