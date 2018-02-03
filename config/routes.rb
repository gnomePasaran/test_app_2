Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  root to: 'users#index'

  get :day_info, to: 'users#day_info'
  get :week_info, to: 'users#week_info'

  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index, :create] do
        post :like, on: :member
      end
    end
  end
end
