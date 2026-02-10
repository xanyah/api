# frozen_string_literal: true

class Sale < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :store, optional: false
  belongs_to :user, optional: false

  has_one :sale_promotion, dependent: :destroy

  has_many :sale_payments, dependent: :destroy
  has_many :sale_products, dependent: :destroy
  has_many :products, through: :sale_products

  accepts_nested_attributes_for :sale_promotion, allow_destroy: true
  accepts_nested_attributes_for :sale_payments, allow_destroy: true
  accepts_nested_attributes_for :sale_products, allow_destroy: true

  validates_ownership_of :customer, with: :store
  validates :created_at,
            absence: true,
            unless: proc { |s| s.store&.is_import_enabled? },
            on: :create

  monetize :total_amount_cents

  after_create :update_stock

  private

  def update_stock
    is_refund = sale_payments.any? { |payment| payment.payment_type&.is_refund }

    sale_products.each do |sale_product|
      update_product_stock(sale_product, is_refund) unless sale_product.product.nil?
    end
  end

  def update_product_stock(sale_product, is_refund)
    new_quantity = if is_refund
                     sale_product.product.quantity + sale_product.quantity
                   else
                     sale_product.product.quantity - sale_product.quantity
                   end

    sale_product.product.update(quantity: new_quantity)
  end
end
