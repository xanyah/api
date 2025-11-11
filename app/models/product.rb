# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category, optional: false
  belongs_to :manufacturer, optional: false
  belongs_to :store, optional: false
  belongs_to :vat_rate, optional: false

  validates_ownership_of :category, with: :store
  validates_ownership_of :manufacturer, with: :store

  has_many :product_custom_attributes, dependent: :destroy

  accepts_nested_attributes_for :product_custom_attributes

  monetize :buying_amount_cents, :tax_free_amount_cents, :amount_cents

  validates :name, presence: true
  validates :sku, uniqueness: { scope: :store }

  after_commit :sync_with_shopify

  has_many_attached :images do |attachable|
    # Used for OpenGraph previews
    attachable.variant :open_graph,
                       resize_to_fill: [1200, 630],
                       preprocessed: true

    # Used for product previews in lists
    attachable.variant :thumbnail,
                       resize_to_fill: [240, 192],
                       preprocessed: true

    # Used for product previews in cards
    attachable.variant :medium,
                       resize_to_fill: [400, 300],
                       preprocessed: true

    # Used for biggest picture on product page
    attachable.variant :large,
                       resize_to_fill: [1600, 1200],
                       preprocessed: true
  end

  def archive!
    update(archived_at: Time.current)
  end

  def unarchive!
    update(archived_at: nil)
  end

  private

  def sync_with_shopify
    Shopify::ProductSyncJob.perform_later(id) if store.shopify_enabled?
  end
end
