# frozen_string_literal: true

class SetSaleProductsProductIdAsNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :sale_products, :product_id, true
  end
end
