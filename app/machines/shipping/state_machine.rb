# frozen_string_literal: true

class Shipping
  module StateMachine
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :state, timestamps: true do
        state :pending, initial: true
        state :validated
        state :cancelled

        event :validate, before: :insert_products do
          transitions from: %i[pending cancelled], to: :validated
        end

        event :cancel, before: :extract_products do
          transitions from: :validated, to: :cancelled
        end
      end

      def insert_products
        shipping_products.each do |shipping_product|
          insert_product(shipping_product)
        end
      end

      def insert_product(shipping_product)
        product = shipping_product.product
        product.quantity = product.quantity + shipping_product.quantity
        product.buying_amount = shipping_product.new_buying_amount if shipping_product.new_buying_amount_cents.present?
        product.amount = shipping_product.new_selling_amount if shipping_product.new_selling_amount_cents.present?
        product.save
      end

      def extract_products
        shipping_products.each do |shipping_product|
          shipping_product.product.update(quantity: shipping_product.product.quantity - shipping_product.quantity)
        end
      end
    end
  end
end
