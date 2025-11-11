# frozen_string_literal: true

class Store < ApplicationRecord
  belongs_to :country
  has_many :admin_store_memberships, -> { admin }, class_name: 'StoreMembership', inverse_of: :store
  has_many :admins, source: :user, through: :admin_store_memberships
  has_many :categories, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :custom_attributes, dependent: :destroy
  has_many :inventories, dependent: :destroy
  has_many :inventory_products, through: :inventories
  has_many :manufacturers, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :owner_store_memberships, -> { owner }, class_name: 'StoreMembership', inverse_of: :store
  has_many :owners, source: :user, through: :owner_store_memberships
  has_many :payment_types, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :providers, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :shippings, dependent: :destroy
  has_many :shipping_products, through: :shippings
  has_many :store_memberships, dependent: :destroy
  has_many :users, through: :store_memberships
  validates :key, presence: true, uniqueness: true, allow_nil: false
  validates :name, presence: true

  def shopify_enabled?
    shopify_shop.present? && shopify_access_token.present?
  end
end
