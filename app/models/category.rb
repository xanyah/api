# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :store, optional: false
  belongs_to :category, optional: true

  after_commit :sync_with_shopify

  validates_ownership_of :category, with: :store

  validates :name, presence: true, uniqueness: { scope: %i[category store] }

  scope :without_category, -> { where(category_id: nil) }
  scope :children_of, ->(id) { where(category_id: id) }

  private

  def sync_with_shopify
    return if previous_changes.key?('shopify_id') || !store.shopify_enabled?

    Shopify::CategorySyncJob.perform_later(id)
  end
end
