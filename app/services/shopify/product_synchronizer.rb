# frozen_string_literal: true

module Shopify
  class ProductSynchronizer
    include Shopify::SyncLogging

    def initialize(product, shopify_client, collection_manager, payload_builder, max_retries:)
      @product = product
      @shopify_client = shopify_client
      @collection_manager = collection_manager
      @payload_builder = payload_builder
      @max_retries = max_retries
    end

    def sync_existing
      shopify_product = fetch_and_validate_shopify_product(product.shopify_product_id)
      shopify_variant = shopify_product['variants'].first

      collection_manager.add_to_collections(product.shopify_product_id, max_retries: max_retries)
      update_variant_with_logging(shopify_variant['id'])
      update_sync_timestamp
    end

    def create_new
      log_product_creation
      shopify_product, shopify_variant = create_and_validate_product
      finalize_product_creation(shopify_product, shopify_variant)
    end

    private

    attr_reader :product, :shopify_client, :collection_manager, :payload_builder, :max_retries

    def log_product_creation
      Rails.logger.info("Creating new Shopify product for product_id=#{product.id}, name=#{product.name}")
    end

    def create_and_validate_product
      shopify_product = create_shopify_product
      validate_shopify_response!(shopify_product)
      shopify_variant = shopify_product['variants'].first
      [shopify_product, shopify_variant]
    end

    def finalize_product_creation(shopify_product, shopify_variant)
      collection_manager.add_to_collections(shopify_product['id'], max_retries: max_retries)
      update_variant_with_logging(shopify_variant['id'])
      save_shopify_product_ids(shopify_product, shopify_variant)
    end

    def fetch_and_validate_shopify_product(shopify_product_id)
      Rails.logger.info("Updating Shopify product shopify_product_id=#{shopify_product_id}")
      shopify_product = update_shopify_product(shopify_product_id)
      log_shopify_product_response(shopify_product)
      validate_shopify_response!(shopify_product)
      shopify_product
    end

    def update_shopify_product(product_shopify_id)
      shopify_client
        .put(path: "products/#{product_shopify_id}",
             body: { product: payload_builder.product_payload }, tries: max_retries)
        .body['product']
    end

    def create_shopify_product
      response = shopify_client.post(path: 'products',
                                     body: { product: payload_builder.product_payload },
                                     tries: max_retries)
      shopify_product = response.body['product']
      log_shopify_product_response(shopify_product)
      shopify_product
    end

    def validate_shopify_response!(shopify_product)
      if shopify_product.nil?
        Rails.logger.error("Shopify API returned nil product for product_id=#{product.id}")
        raise 'Shopify API returned nil product response'
      end

      return if shopify_product['variants'].present?

      Rails.logger.error("Shopify API returned product without variants for product_id=#{product.id}")
      raise 'Shopify API returned product without variants'
    end

    def update_variant_with_logging(variant_id)
      Rails.logger.info("Updating Shopify variant variant_id=#{variant_id}")
      update_shopify_variant(variant_id)
    end

    def update_shopify_variant(variant_id)
      shopify_client.put(path: "variants/#{variant_id}",
                         body: { variant: payload_builder.variant_payload },
                         tries: max_retries)
    end

    def update_sync_timestamp
      product.update_columns(shopify_updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
      Rails.logger.info("Synced existing product product_id=#{product.id}")
    end

    def save_shopify_product_ids(shopify_product, shopify_variant)
      product.update_columns(shopify_product_id: shopify_product['id'], # rubocop:disable Rails/SkipsModelValidations
                             shopify_variant_inventory_item_id: shopify_variant['inventory_item_id'],
                             shopify_updated_at: Time.current)
      Rails.logger.info(
        "Created new Shopify product: product_id=#{product.id}, " \
        "shopify_product_id=#{shopify_product['id']}, inventory_item_id=#{shopify_variant['inventory_item_id']}"
      )
    end
  end
end
