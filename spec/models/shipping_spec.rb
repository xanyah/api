# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shipping do
  it :has_valid_factory do
    expect(build(:shipping)).to be_valid
  end

  it :is_paranoid do
    shipping = create(:shipping)
    expect(shipping.deleted_at).to be_nil
    expect(described_class.all).to include(shipping)
    shipping.destroy
    expect(shipping.deleted_at).not_to be_nil
    expect(described_class.all).not_to include(shipping)
  end

  describe 'validate' do
    let(:shipping) { create(:shipping) }

    it :validates do
      shipping.validate!
      shipping.reload
      expect(shipping.validated_at).not_to be_nil
    end

    it :updates_products_quantity do
      sproduct1 = create(:shipping_product, shipping: shipping)
      sproduct1_qty = sproduct1.product.quantity
      sproduct2 = create(:shipping_product, shipping: shipping)
      sproduct2_qty = sproduct2.product.quantity
      sproduct3 = create(:shipping_product)
      sproduct3_qty = sproduct3.product.quantity
      shipping.validate!
      expect(sproduct1.reload.product.quantity).to eq(sproduct1_qty + sproduct1.quantity)
      expect(sproduct2.reload.product.quantity).to eq(sproduct2_qty + sproduct2.quantity)
      expect(sproduct3.reload.product.quantity).not_to eq(sproduct3_qty + sproduct3.quantity)
    end

    it :updates_products_amount_when_new_amount_is_present do
      original_amount = Money.new(5000)
      new_amount = Money.new(7500)
      product = create(:product, store: shipping.store, amount: original_amount)
      sproduct = create(:shipping_product, shipping: shipping, product: product, new_amount: new_amount)
      
      shipping.validate!
      
      expect(sproduct.reload.product.amount).to eq(new_amount)
    end

    it :does_not_update_products_amount_when_new_amount_is_not_present do
      original_amount = Money.new(5000)
      product = create(:product, store: shipping.store, amount: original_amount)
      sproduct = create(:shipping_product, shipping: shipping, product: product, new_amount_cents: nil)
      
      shipping.validate!
      
      expect(sproduct.reload.product.amount).to eq(original_amount)
    end

    it :updates_multiple_products_with_different_amounts do
      product1 = create(:product, store: shipping.store, amount: Money.new(1000))
      product2 = create(:product, store: shipping.store, amount: Money.new(2000))
      product3 = create(:product, store: shipping.store, amount: Money.new(3000))
      
      sproduct1 = create(:shipping_product, shipping: shipping, product: product1, new_amount: Money.new(1500))
      sproduct2 = create(:shipping_product, shipping: shipping, product: product2, new_amount_cents: nil)
      sproduct3 = create(:shipping_product, shipping: shipping, product: product3, new_amount: Money.new(3500))
      
      shipping.validate!
      
      expect(product1.reload.amount).to eq(Money.new(1500))
      expect(product2.reload.amount).to eq(Money.new(2000))
      expect(product3.reload.amount).to eq(Money.new(3500))
    end
  end

  describe 'cancel' do
    let(:shipping) { create(:shipping) }

    it :cancels do
      shipping.update(state: :validated)
      shipping.cancel!
      shipping.reload
      expect(shipping.cancelled_at).not_to be_nil
    end

    it :updates_products_quantity do
      sproduct1 = create(:shipping_product, shipping: shipping)
      sproduct1_qty = sproduct1.product.quantity
      sproduct2 = create(:shipping_product, shipping: shipping)
      sproduct2_qty = sproduct2.product.quantity
      sproduct3 = create(:shipping_product)
      sproduct3_qty = sproduct3.product.quantity
      shipping.update(state: :validated)
      shipping.reload.cancel!
      expect(sproduct1.reload.product.quantity).to eq(sproduct1_qty - sproduct1.quantity)
      expect(sproduct2.reload.product.quantity).to eq(sproduct2_qty - sproduct2.quantity)
      expect(sproduct3.reload.product.quantity).not_to eq(sproduct3_qty - sproduct3.quantity)
    end
  end
end
