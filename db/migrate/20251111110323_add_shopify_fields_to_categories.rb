# frozen_string_literal: true

class AddShopifyFieldsToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :shopify_id, :string
    add_column :categories, :shopify_updated_at, :datetime
  end
end
