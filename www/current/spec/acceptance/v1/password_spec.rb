require 'acceptance_helper'

resource 'Password' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/v1/passwords' do
    let(:user) { create(:user) }
    let(:raw_post) do
      {
        data: {
          type: 'passwords',
          attributes: {
            email: user.email,
          }
        }
      }.to_json
    end

    example_request 'Forgot Password' do
      explanation <<~MSG
        Sends a reset password link to the user's email.
      MSG

      expect(status).to eql 200
    end
  end

  patch '/v1/passwords' do
    let(:user) { create(:user, password: 'old_password', password_confirmation: 'old_password') }
    let(:raw_post) do
      {
        data: {
          type: 'passwords',
          attributes: {
            reset_password_token: user.recover_password,
            password: 'password',
            password_confirmation: 'password'
          }
        }
      }.to_json
    end

    example_request 'Update Password' do
      explanation <<~MSG
      It updates the password of a user using the reset password token. It can
      also be used to update password of a logged in user by providing the authorization
      token and replacing `reset_password_token` with `current_password`.
      MSG

      expect(status).to eql 200
    end
  end
end
