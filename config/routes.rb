Rails.application.routes.draw do
  # welcome
  root 'welcome#index'

  # admin
  get '/admin', to: 'admin#index'

  namespace :admin do
    resources :merchants, only: [:index, :create, :new, :show, :edit, :update]
    resources :invoices, only: [:index, :show, :update]
  end

  # merchants
  get '/merchants/:merchant_id/dashboard', to: 'merchants#show'
  patch 'merchants/:merchant_id/items/:id', to: 'items#update'
  patch 'merchants/:merchant_id/bulk_discounts/:id', to: 'bulk_discounts#update'

  resources :merchants, only: [] do
    resources :items, only: [:index, :show, :edit, :new, :create]
    resources :item_status, only: [:update]
    resources :invoices, only: [:index, :show, :update]
    resources :bulk_discounts, only: [:index, :destroy, :show, :create, :new, :edit]
  end
end
