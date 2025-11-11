# frozen_string_literal: true

class AddShopifyFieldsToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :shopify_shop, :string
    add_column :stores, :shopify_access_token, :string
    add_column :stores, :shopify_updated_at, :datetime
  end
end
