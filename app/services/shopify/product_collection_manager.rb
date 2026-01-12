# frozen_string_literal: true

module Shopify
  class ProductCollectionManager
    def initialize(product, shopify_client)
      @product = product
      @shopify_client = shopify_client
    end

    def add_to_collections(shopify_product_id, max_retries:)
      Rails.logger.info("Adding product to Shopify collections: shopify_product_id=#{shopify_product_id}")
      add_category_collection(shopify_product_id, max_retries)
      add_manufacturer_collection(shopify_product_id, max_retries)
      Rails.logger.info('Added product to collections')
    end

    private

    attr_reader :product, :shopify_client

    def add_category_collection(shopify_product_id, max_retries)
      category_shopify_id = product.category&.shopify_id
      return if category_shopify_id.nil?

      add_to_collection(shopify_product_id, category_shopify_id, max_retries)
    end

    def add_manufacturer_collection(shopify_product_id, max_retries)
      manufacturer_shopify_id = product.manufacturer&.shopify_id
      return if manufacturer_shopify_id.nil?

      add_to_collection(shopify_product_id, manufacturer_shopify_id, max_retries)
    end

    def add_to_collection(product_shopify_id, collection_shopify_id, max_retries)
      shopify_client.post(path: 'collects',
                          body: { collect: { product_id: product_shopify_id, collection_id: collection_shopify_id } },
                          tries: max_retries)
    end
  end
end
