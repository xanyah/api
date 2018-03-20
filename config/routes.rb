# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  resources :categories, except: [:destroy]

  resources :custom_attributes

  resources :inventories, except: [:update] do
    patch :lock, on: :member
    put :lock, on: :member
  end
  resources :inventory_variants

  resources :manufacturers, except: [:destroy]

  resources :products, except: [:destroy]

  resources :providers, except: [:destroy]

  resources :shippings, except: [:update] do
    patch :lock, on: :member
    put :lock, on: :member
  end
  get 'shipping_variants/:shipping_id/:variant_id', to: 'shipping_variants#by_variant'
  resources :shipping_variants

  resources :stock_backup_variants, only: %i[index show]
  resources :stock_backups, only: %i[index show]

  resources :store_memberships
  resources :stores, except: [:destroy]

  resources :variant_attributes
  resources :variants, except: [:destroy] do
    get :by_barcode, on: :member
  end
end
