Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :stores
  resources :users

  namespace :api do
    namespace :v1 do
      jsonapi_resources :stores do end
      jsonapi_resources :status_crowdsource_users, only: [:create] do end
      jsonapi_resources :status_crowdsources, only: [:index] do end
    end
  end
end
