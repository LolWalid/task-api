require 'rails_helper'

RSpec.describe 'API::V1::UsersController', type: :request do
  describe 'GET #login' do
    it 'returns http success' do
      post login_api_users_path
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #sign_up' do
    it 'returns http success' do
      post sign_up_api_users_path
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
