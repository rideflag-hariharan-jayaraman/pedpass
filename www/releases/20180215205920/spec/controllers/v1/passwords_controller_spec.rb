# frozen_string_literal: true
describe V1::PasswordsController do
  include ActiveSupport::Testing::TimeHelpers

  before do
    @request.headers['Content-Type'] = 'application/vnd.api+json'
  end


  describe 'POST #create' do
    let!(:user) { FactoryBot.create(:user) }

    it 'returns a success response when sent a valid email' do
      post  :create, params: {
        data: {
          type: 'passwords',
          attributes: { email: user.email }
        }
      }


      expect(response).to_not be_nil
      expect(response.status).to eq(200)

      data = JSON.parse(response.body)['data']
      expect(data.first['type']).to eq('passwords')
    end

    it 'returns an error if the email entered is not found' do
      post :create, params: {
        data: {
          type: 'passwords',
          attributes: { email: 'INCORRECT_EMAIL@devbbq.com', reset_url: 'https://network.completeconcussions.com/users/reset/' }
        }
      }

      expect(response.status).to eq(422)
      expect(response.body).to include '/data/attributes/email'
    end
  end

  describe 'POST #update' do
    context 'when resetting your password' do
      let!(:user) { FactoryBot.create(:user) }
      before(:each) do
        @token = user.recover_password
      end

      it 'returns a success response when updated with a valid token' do
        patch :update, params: {
          data: {
            type: 'passwords',
            attributes: { reset_password_token: @token, password: 'new_password', password_confirmation: 'new_password' }
          }
        }

        expect(response.status).to eq(200)
      end

      it 'returns an error when updated with an invalid token' do
        patch :update, params: {
          data: {
            type: 'passwords',
            attributes: { reset_password_token: 'INCORRECT_TOKEN', password: 'new_password', password_confirmation: 'new_password' }
          }
        }

        expect(response.status).to eq(422)
        expect(response.body).to include '/data/attributes/reset-password-token'
      end

      it 'returns an error when updated with an expired token' do
        travel(1.year) do
          patch :update, params: {
            data: {
              type: 'passwords',
              attributes: { reset_password_token: @token, password: 'new_password', password_confirmation: 'new_password' }
            }
          }
        end

        expect(response.status).to eq(422)
        expect(response.body).to include '/data/attributes/reset-password-token'
      end

      it 'returns an error when the passwords do not match' do
        patch :update, params: {
          data: {
            type: 'passwords',
            attributes: { reset_password_token: @token, password: 'new_password', password_confirmation: 'different_password' }
          }
        }

        expect(response.status).to eq(422)
        expect(response.body).to include '/data/attributes/password-confirmation'
      end
    end

    context 'when logged in' do
      let!(:device) { create(:device, user: create(:user, password: 'old_password')) }

      it 'lets the user change their own password' do
        @request.headers['Authorization'] = authorize_device(device)

        patch :update, params: {
          data: {
            type: 'passwords',
            attributes: {
              password: 'new_password',
              password_confirmation: 'new_password',
              current_password: 'old_password'
            }
          }
        }

        expect(response.status).to eq(200)

        data = JSON.parse(response.body)['data']
        expect(data['type']).to eq('users')
      end

      it 'returns an error if your password is incorrect' do
        @request.headers['Authorization'] = authorize_device(device)

        patch :update, params: {
          data: {
            type: 'passwords',
            attributes: {
              password: 'new_password',
              password_confirmation: 'new_password',
              current_password: 'WRONG_password'
            }
          }
        }

        expect(response.status).to eq(422)
        expect(response.body).to include '/data/attributes/current-password'
      end
    end
  end
end
