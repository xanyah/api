# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
  include DeviseTokenAuth::Concerns::User

  has_many :store_memberships, dependent: :destroy
  has_many :stores, through: :store_memberships
  has_many :categories, through: :stores
  has_many :clients, through: :stores
  has_many :custom_attributes, through: :stores
  has_many :inventories, through: :stores
  has_many :manufacturers, through: :stores
  has_many :orders, through: :stores
  has_many :payment_types, through: :stores
  has_many :products, through: :stores
  has_many :providers, through: :stores
  has_many :sales, through: :stores
  has_many :shippings, through: :stores
  has_many :shipping_variants, through: :stores
  has_many :stock_backups, through: :stores
  has_many :stock_backup_variants, through: :stores
  has_many :stores_store_memberships, through: :stores, source: :store_memberships
  has_many :inventory_variants, through: :stores
  has_many :variants, through: :products
  has_many :variant_attributes, through: :stores

  def token_validation_response
    as_json(except: %i[
              tokens created_at updated_at
            ])
  end

  def tokens_has_json_column_type?
    database_exists? && table_exists? && type_for_attribute('tokens').type.in?(%i[json jsonb])
  end
end
