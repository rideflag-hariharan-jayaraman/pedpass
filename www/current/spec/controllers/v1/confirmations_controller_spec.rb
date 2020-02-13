# frozen_string_literal: true
describe V1::ConfirmationsController do
  include ActiveSupport::Testing::TimeHelpers

  before do
    @request.headers['Content-Type'] = 'application/vnd.api+json'
  end

  describe 'POST #create' do
    let!(:user) { FactoryBot.create(:user) }

    it 'returns a success response when sent a valid email' do
      post  :create, params: {
        data: {
          type: 'confirmations',
          attributes: { email: user.email }
        }
      }


      expect(response).to_not be_nil
      expect(response.status).to eq(200)

      data = JSON.parse(response.body)['data']
      expect(data.first['type']).to eq('confirmations')
    end

    it 'returns an error if the email entered is not found' do
      post :create, params: {
        data: {
          type: 'confirmations',
          attributes: { email: 'INCORRECT_EMAIL@devbbq.com' }
        }
      }

      expect(response.status).to eq(422)
      expect(response.body).to include '/data/attributes/email'
    end
  end
end
