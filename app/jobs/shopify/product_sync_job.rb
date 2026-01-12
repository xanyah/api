# frozen_string_literal: true

module Shopify
  class ProductSyncJob < BaseJob
    include Shopify::SyncLogging

    attr_reader :product

    def perform(product_id)
      setup_product(product_id)
      log_sync_start(product_id)
      sync_product
      update_shopify_quantity
      log_sync_completion(product_id)
    end

    private

    def setup_product(product_id)
      @product = Product.find(product_id)
      @store = @product.store
    end

    def sync_product
      if product.shopify_product_id.present?
        Rails.logger.info("Syncing existing Shopify product shopify_product_id=#{product.shopify_product_id}")
        synchronizer.sync_existing
      else
        Rails.logger.info("Creating new Shopify product for product_id=#{product.id}")
        synchronizer.create_new
      end
    end

    def get_store_id(arguments)
      Product.find(arguments.first).store.id
    end

    def update_shopify_quantity
      log_inventory_update_start
      shopify_client.post(path: 'inventory_levels/set',
                          body: inventory_update_body,
                          tries: MAX_RETRIES)
      log_inventory_update_success
    end

    def inventory_update_body
      {
        location_id: product.store.shopify_location_id,
        inventory_item_id: product.shopify_variant_inventory_item_id,
        available: product.quantity
      }
    end

    def synchronizer
      @synchronizer ||= Shopify::ProductSynchronizer.new(
        product,
        shopify_client,
        collection_manager,
        payload_builder,
        max_retries: MAX_RETRIES
      )
    end

    def collection_manager
      @collection_manager ||= Shopify::ProductCollectionManager.new(product, shopify_client)
    end

    def payload_builder
      @payload_builder ||= Shopify::ProductPayloadBuilder.new(product)
    end
  end
end
