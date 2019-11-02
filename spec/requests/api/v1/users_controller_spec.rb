require 'rails_helper'

RSpec.describe 'API::V1::UsersController', type: :request do
  let(:password) { 'valid_password' }
  let(:user) { create(:user, password: password) }

  describe 'POST #login' do
    context 'with valid params' do
      let(:login_params) do
        {
          email: user.email,
          password: password
        }
      end

      before(:each) do
        post login_api_users_path, params: { user: login_params }
        @response_body = JSON.parse(response.body).symbolize_keys
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(@response_body).to have_key(:token) }
      it { expect(@response_body).to have_key(:expire) }
    end

    context 'with unvalid params' do
      let(:unvalid_login_params) do
        {
          email: user.email,
          password: password + 'unvalid'
        }
      end

      it 'returns unauthorized if not params' do
        post login_api_users_path
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized' do
        post login_api_users_path, params: { user: unvalid_login_params }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #sign_up' do
    context 'with valid params' do
      let(:sign_up_params) do
        {
          email: 'john@doe.com',
          password: password,
          password_confirmation: password,
          firstname: 'john',
          lastname: 'doe'
        }
      end

      it 'returns http success' do
        post sign_up_api_users_path, params: { user: sign_up_params }
        expect(response).to have_http_status(:created)
      end

      it 'creates a new user' do
        expect do
          post sign_up_api_users_path, params: { user: sign_up_params }
        end.to change(User, :count).by(1)
      end
    end

    context 'with unvalid params' do
      it 'returns http success' do
        post sign_up_api_users_path
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
