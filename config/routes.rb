Rails.application.routes.draw do
  # Authentication
  devise_for :users

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root path
  root "dashboard#index"

  # User dashboard
  get "dashboard", to: "dashboard#index", as: :user_dashboard

  # Profile
  resource :profile, only: [ :show, :edit, :update ]

  # Categories (User managed)
  resources :categories
  resources :rewards, only: [ :show ]

  # Sankalps with nested daily activities
  resources :sankalps do
    resources :daily_activities do
      member do
        post :toggle
      end
    end
  end

  # Admin namespace
  namespace :admin do
    root "dashboard#index"

    resources :dashboard, only: [ :index ]
    resources :users, except: [ :new, :create ]
    resources :sankalps, except: [ :new, :create ]
    resources :categories
  end
end
