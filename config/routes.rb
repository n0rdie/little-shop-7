Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :merchants, only: :index do
    resources :dashboard, only: [:index], controller: "merchant/dashboard"
    resources :items, only: [:index, :show, :edit, :update, :new, :create], controller: "merchant/items"
    resources :invoices, only: [:index, :show], controller: "merchant/invoices"
    resources :coupons, only: [:index, :new, :create, :show, :update], controller: "merchant/coupons"
  end
  patch "/merchants/:merchant_id/invoice_items/:invoice_item_id", to: "merchant/invoice_items#update"

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    patch "/merchants/:id", to: "merchants#update", as: :update_merchant
    patch 'merchants/:id/update_info', to: 'merchants#update_info', as: 'merchant_update_info'
    resources :merchants, only: [:index, :new, :create, :show, :edit, :update] 
    resources :invoices, only: [:index, :show, :update]
  end
end
