Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api do
    resources :posts do
      get :search , on: :collection
    end
    resources :posts, only: [:index, :show, :create, :update, :destroy]
  end
end
