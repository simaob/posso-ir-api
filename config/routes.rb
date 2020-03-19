Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :stores
  resources :users

  namespace :api do
    namespace :v1 do
      jsonapi_resources :stores
      jsonapi_resources :status_crowdsource_users, only: [:create]
      jsonapi_resources :status_crowdsources, only: [:index]
    end
  end
end
