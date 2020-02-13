Rails.application.routes.draw do
  if defined? Apitome
    root 'apitome/docs#index'
  else
    root 'rails_admin/main#dashboard'
  end

  namespace :v1 do
    resource :device, :user, only: %i[create show]
    resources :crossings, only: %i[index show] do
      post :check_for_success, :completed, on: :collection
    end
    resources :detected_corners, only: %i[index create show]
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'


  # namespace :admin do
  #   root 'users#index'
  #
  #   resources :users, :devices, :crossings, :detected_corners, only: %i[index show]
  #   resources :intersections
  #   resources :corners, except: %i[destroy]
  #   resources :beacons, :crosswalks
  #   resources :crossing_failure_reasons, :settings, except: %i[new destroy]
  # end
end
