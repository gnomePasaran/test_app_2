Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  root to: 'users#index'

  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index, :create] do
        post :like, on: :member
      end
    end
  end
end
