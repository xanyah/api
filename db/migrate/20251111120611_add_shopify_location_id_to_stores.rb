class AddShopifyLocationIdToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :shopify_location_id, :string
  end
end
