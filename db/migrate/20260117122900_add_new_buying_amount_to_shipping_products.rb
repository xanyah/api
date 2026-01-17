# frozen_string_literal: true

class AddNewBuyingAmountToShippingProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :shipping_products, :new_amount_cents, :integer
    add_column :shipping_products, :new_amount_currency, :string, default: 'EUR', null: false
  end
end
