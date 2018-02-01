Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  root to: 'users#index'

  resources :users, only: :index
end
