# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  default_url_options host: ENV.fetch('RAILS_DEFAULT_HOST', 'localhost:3000')
  devise_for :users, only: []

  namespace :v2 do
    resources :categories
    resources :countries, only: %i[index show]
    resource :current_user, controller: :current_user, except: :destroy
    resources :customers
    resources :custom_attributes
    resources :file_imports, only: :create
    resources :inventories, except: [:update] do
      patch :lock, on: :member
      put :lock, on: :member
    end
    resources :inventory_products
    resources :manufacturers
    resources :orders, except: :destroy do
      patch :cancel, on: :member
      patch :deliver, on: :member
      patch :order, on: :member
      patch :withdraw, on: :member
    end
    resources :order_products, only: :index
    resources :payment_types
    resources :products do
      get :next_sku, on: :collection
    end
    resources :providers
    resources :sale_payments, only: :index
    resources :sale_products, only: :index
    resources :sales
    resources :shippings do
      patch :validate, on: :member
      patch :cancel, on: :member
    end
    resources :shipping_products
    resources :store_memberships, except: :create
    resources :stores, except: :create
    resources :vat_rates, only: %i[index show]
  end
end
