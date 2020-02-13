# frozen_string_literal: true
require 'rails_helper'

describe V1::SessionsController  do
  let(:user) { create(:user, :with_device) }

  before do
    @request.headers['Content-Type'] = 'application/vnd.api+json'
  end


  describe 'POST login' do
    context 'with a confirmed email' do
      before(:each) do
        user.confirm
      end

      it 'returns an authentication token with valid credentials' do
        post :create, params: {
          data: {
            type: 'sessions',
            attributes: {
              email: user.email,
              password: user.password,
              device: user.devices.first.uuid
            }
          }
        }

        expect(response).to_not be_nil
        expect(response.status).to eq 200

        json = JSON.parse(response.body)
        expect(json['data']['attributes']['token']).to_not be_nil
        expect(json['data']['attributes']['confirmed']).to be true
        expect(json['data']['attributes']['profile-attributes']).to_not be_nil
      end

      it 'creates new device if device doesn\'t exist' do
        post  :create, params: {
          data: {
            type: 'sessions',
            attributes: {
              email: user.email,
              password: user.password,
              device: 'some random device token'
            }
          }
        }

        expect(response.status).to eq 200
        expect(user.devices.count).to eq 2
      end

      it 'returns an unauthorized error with invalid credentials' do
        post  :create, params: {
          data: {
            type: 'sessions',
            attributes: {
              email: user.email,
              password: 'some random password that should not be the password',
              device: user.devices.first.uuid
            }
          }
        }

        expect(response.status).to eq(401)

        json = JSON.parse(response.body)
        expect(json['errors'].first['status']).to eq('401')
      end
    end

    context 'without a confirmed email' do
      before { user.update(confirmed_at: nil) }
      subject do
        post  :create, params: {
          data: {
            type: 'sessions',
            attributes: {
              email: user.email,
              password: user.password,
              device: user.devices.first.uuid
            }
          }
        }
        response
      end

      it { should have_http_status  200 }
      it 'allows you to still log in' do
        json = JSON.parse(subject.body)
        expect(json['data']['attributes']['token']).to_not be_nil
        expect(json['data']['attributes']['confirmed']).to be false
      end
      it 'returns whether the user has confirmed their email address' do
        json = JSON.parse(subject.body)
        expect(json['data']['attributes']['confirmed']).to be false
      end
    end
  end

  describe 'POST oauth' do
    let(:token) { 'some_random_token' }

    context 'success' do
      before do
        allow_any_instance_of(Koala::Facebook::API)
        .to receive(:get_object)
        .and_return(JSON.parse({
          email: 'user@example.com', age_range: { min: 20, max: 23 }, gender: 'male'
        }.to_json))
      end

      it 'signs in user and provides session token' do
        post :oauth, params: {
          auth_provider: 'facebook',
          auth: { device: 'testdevice123', auth_token: token }
        }

        expect(response).to have_http_status 200

        json = JSON.parse(response.body)
        expect(json['data']['attributes']['token']).to_not be_nil
      end

      context 'with facebook token for new user' do
        subject do
          post :oauth, params: {
            auth_provider: 'facebook',
            auth: { device: 'testdevice123', auth_token: token }
          }
          response
        end

        it { expect{ subject }.to change{User.count}.by(1) }
      end

      context 'for existing user' do
        before { create(:user, email: 'user@example.com') }
        subject do
          post :oauth, params: {
            auth_provider: 'facebook',
            auth: { device: 'testdevice123', auth_token: token }
          }
          response
        end

        it { expect{ subject }.to change{User.count}.by(0) }
        it { expect{ subject }.to change{Identity.count}.by(1) }
      end
    end

    context 'error' do
      context 'missing field info' do
        before do
          allow_any_instance_of(Koala::Facebook::API)
          .to receive(:get_object)
          .and_return(JSON.parse({
            email: 'user@example.com', age_range: { min: 20, max: 23 }, gender: 'male'
          }.to_json))
        end
        subject do
          post :oauth, params: {
            auth_provider: 'facebook',
            auth: { auth_token: token }
          }
          response
        end

        it { should have_http_status 422 }
      end

      context 'invalid token' do
        subject do
          post :oauth, params: {
            auth_provider: 'facebook',
            auth: { auth_token: 'invalid_token' }
          }
          response
        end

        it { should have_http_status 401 }
      end
    end
  end
end
