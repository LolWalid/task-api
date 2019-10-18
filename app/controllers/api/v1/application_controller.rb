module API::V1
  class ApplicationController < ActionController::API
    include JWTAuthenticable
  end
end
