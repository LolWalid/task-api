module API::V1
  class UsersController < ApplicationController
    before_action :authenticate!, only: :refresh_token
    # around_action :set_time_zone

    # def set_time_zone(&block)
    #   Time.use_zone('Paris', &block)
    # end

    before_action :set_time_zone

    def set_time_zone
      Time.zone = 'Paris'
    end

    def sign_up
      @user = User.new(user_params)
      if @user.save
        token = JSONWebToken.encode(user_id: @user.id)
        render json: { token: token, expire: User::JWT_DURATION.from_now }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def login
      @user = User.find_by(email: login_params[:email])
      if @user&.authenticate(login_params[:password])
        token = JSONWebToken.encode(user_id: @user.id)
        render json: { token: token, expire: User::JWT_DURATION.from_now }, status: :ok
      else
        head :unauthorized, content_type: 'application/json'
      end
    end

    def refresh_token
      token = JSONWebToken.encode(user_id: current_user.id)
      render json: { token: token, expire: User::JWT_DURATION.from_now }, status: :ok
    end

    private

    def login_params
      params.fetch(:user, {}).permit(:email, :password)
    end

    def user_params
      params.fetch(:user, {})
            .permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end
  end
end
