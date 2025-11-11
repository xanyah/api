# frozen_string_literal: true

class AddShopifyFieldsToManufacturers < ActiveRecord::Migration[8.0]
  def change
    add_column :manufacturers, :shopify_id, :string
    add_column :manufacturers, :shopify_updated_at, :datetime
  end
end
