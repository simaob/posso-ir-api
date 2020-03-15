Rails.application.routes.draw do
  resources :stores
  devise_for :users
  root to: "home#index"
end
