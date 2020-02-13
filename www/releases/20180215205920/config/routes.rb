Rails.application.routes.draw do
  if defined? Apitome
    root 'apitome/docs#index'
  else
    root 'rails_admin/main#dashboard'
  end

  devise_for :users, only: [ :confirmation, :password ], controllers: {
    confirmations: "users/confirmations"
  }

  namespace :v1 do
    resource :options, only: [:show]
    resource :passwords, only: [:create, :update]
    resource :sessions, only: [:create]
    resource :confirmations, only: [:create]
    post 'oauth/:auth_provider', to: 'sessions#oauth', as: 'oauth'
    resource :device, only: %i[create show]
    resource :user, only: %i[create show update]
    resources :crossings, only: %i[index show] do
      post :check_for_success, :completed, on: :collection
    end
    resources :detected_corners, only: %i[index create show]
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
