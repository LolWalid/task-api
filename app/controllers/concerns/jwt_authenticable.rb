module JWTAuthenticable
  extend ActiveSupport::Concern

  included do
    # helper_method :current_user
    attr_reader :current_user

    rescue_from JWT::DecodeError do |_e|
      # raise e if Rails.env.development? || Rails.env.test?

      # render json: { errors: e.message }, status: :unauthorized
      head :unauthorized, content_type: 'application/json'
    end
  end

  def authenticate!
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    @decoded = JSONWebToken.decode(header)
    @current_user = User.find(@decoded[:user_id])
  end
end
