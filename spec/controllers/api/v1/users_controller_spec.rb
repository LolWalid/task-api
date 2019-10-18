require 'rails_helper'

RSpec.describe API::V1::UsersController, type: :controller do

  describe "GET #login" do
    it "returns http success" do
      get :login
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #sign_up" do
    it "returns http success" do
      get :sign_up
      expect(response).to have_http_status(:success)
    end
  end

end
