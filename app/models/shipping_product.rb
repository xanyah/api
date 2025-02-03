# frozen_string_literal: true

class ShippingProduct < ApplicationRecord
  belongs_to :product, optional: false
  belongs_to :shipping, optional: false

  has_one :store, through: :product

  validates_ownership_of :shipping, with: :store

  validates :product_id, uniqueness: { scope: :shipping_id }
  validate :shipping_locked

  protected

  def shipping_locked
    errors.add(:shipping, :validated) if shipping.validated?
  end
end
