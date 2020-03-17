Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  namespace :api do
    namespace :v1 do
      jsonapi_resources :stores
    end
  end
end
