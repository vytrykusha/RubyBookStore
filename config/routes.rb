Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  devise_for :users
  resources :books do
    resources :comments, only: [ :create, :destroy ]
  end
  resources :cart_items, only: [ :index, :create, :update, :destroy ]
  resources :orders, only: [ :index, :create, :new, :show ]

  namespace :api do
    namespace :v1 do
      resources :books, only: [ :index, :create ]
    end
  end


  # Chat routes
  get "chat", to: "chat#index"
  post "chat/send_message"
  post "chat/clear"

  # Dashboard routes
  get "dashboard/analytics", to: "dashboard#analytics"
  get "dashboard/api_analytics", to: "dashboard#api_analytics"

  # Payment routes
  post "payments/liqpay/notify", to: "payments#liqpay_notify"
  get "payments/status/:order_id", to: "payments#status", as: :payment_status
  post "payments/mark_payment/:order_id", to: "payments#mark_payment", as: :mark_payment
  get "payments/mark_payment/:order_id", to: "payments#mark_payment"
  post "payments/cash/:order_id", to: "payments#pay_cash", as: :pay_cash

  namespace :admin do
    resources :books
    resources :orders
    resources :users
    resources :comments, only: [ :index, :destroy ]
    get "dashboard", to: "dashboard#index", as: :dashboard
    root "home#index"
  end
      get "about", to: "pages#about", as: :about

  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
