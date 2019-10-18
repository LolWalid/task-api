Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, constraints: { format: :json } do
    concern :api_base do
      resource :users, only: [] do
        post :login
        post :sign_up
        get  :refresh_token
      end
    end

    # v1 is default
    scope '/', module: :v1 do
      concerns :api_base
    end

    namespace :v1 do
      concerns :api_base
    end
  end
end
