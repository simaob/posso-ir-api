Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  scope "(:locale)", locale: /en|pt|es|sk/ do
    root to: "home#index"
    resources :stats, only: [:index]
    resources :stores do
      post :approve_all, on: :collection
      get :statuses, on: :member
      resources :status_store_owners, only: [:new, :create]
    end
    resources :beaches do
      post :approve_all, on: :collection
      get :statuses, on: :member
      resources :status_store_owners, only: [:new, :create]
    end
    resources :status_crowdsource_users, only: [:index]
    resources :manage_stores, only: [:index]
    resources :user_stores, only: [:index, :update]
    resources :phones
    resources :users do
      get :statuses, on: :member
      post :regenerate_key, on: :member
    end
    resources :map
  end

  namespace :api do
    namespace :v1 do
      jsonapi_resources :stores do end
      get 'random-stores', to: 'random_stores#index'
      jsonapi_resources :status_crowdsource_users, only: [:create] do end
      jsonapi_resources :status_store_owners, only: [:create] do end
      jsonapi_resources :status_crowdsources, only: [:index] do end
      jsonapi_resources :status_generals, only: [:index] do end
      jsonapi_resources :random_status_generals, only: [:index] do end

      post 'status-phone', to: 'status_phone#create'
      post 'status-estimations', to: 'status_estimations#create'
    end
  end

  require 'sidekiq/web'
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
