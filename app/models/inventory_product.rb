# frozen_string_literal: true

class InventoryProduct < ApplicationRecord
  belongs_to :product
  belongs_to :inventory
  has_one :store, through: :inventory

  scope :invalid_quantity, -> { eager_load(:product).where('inventory_products.quantity != products.quantity') }

  validates :product_id, uniqueness: { scope: :inventory_id }
  validate :inventory_locked

  def self.ransackable_scopes(_auth_object = nil)
    %i[invalid_quantity]
  end

  protected

  def inventory_locked
    errors.add(:inventory, 'is locked') unless inventory.nil? || inventory.locked_at.nil?
  end
end
