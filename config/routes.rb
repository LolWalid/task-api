Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, constraints: { format: :json } do
    concern :api_base do
      resource :users, only: [:update] do
        post :login
        post :sign_up
        get  :refresh_token
        get :info
      end

      resources :tasks, except: :show do
        put :mark_as_done, on: :member
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
