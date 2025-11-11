# frozen_string_literal: true

class AddShopifyFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :shopify_product_id, :string
    add_column :products, :shopify_variant_inventory_item_id, :string
    add_column :products, :shopify_updated_at, :datetime
  end
end
