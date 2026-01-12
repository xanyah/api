# frozen_string_literal: true

module Shopify
  class ProductSyncJob < BaseJob # rubocop:disable Metrics/ClassLength
    attr_reader :product

    def perform(product_id) # rubocop:disable Metrics/AbcSize
      @product = Product.find(product_id)
      @store = @product.store

      Rails.logger.info("Starting Shopify sync for product_id=#{product_id}, store_id=#{@store.id}")

      if product.shopify_product_id.present?
        Rails.logger.info("Syncing existing Shopify product shopify_product_id=#{product.shopify_product_id}")
        sync_existing_product
      else
        Rails.logger.info("Creating new Shopify product for product_id=#{product_id}")
        create_new_product
      end
      update_shopify_quantity
      Rails.logger.info("Completed Shopify sync for product_id=#{product_id}")
    end

    private

    def get_store_id(arguments)
      Product.find(arguments.first).store.id
    end

    def update_shopify_quantity # rubocop:disable Metrics/AbcSize
      Rails.logger.info("Updating Shopify inventory: product_id=#{product.id}, inventory_item_id=#{product.shopify_variant_inventory_item_id}, quantity=#{product.quantity}")
      shopify_client.post(path: 'inventory_levels/set',
                          body: {
                            location_id: product.store.shopify_location_id,
                            inventory_item_id: product.shopify_variant_inventory_item_id,
                            available: product.quantity
                          },
                          tries: MAX_RETRIES)
      Rails.logger.info("Successfully updated Shopify inventory for product_id=#{product.id}")
    end

    def sync_existing_product # rubocop:disable Metrics/AbcSize
      Rails.logger.info("Updating Shopify product shopify_product_id=#{product.shopify_product_id}")
      shopify_product = update_shopify_product(product.shopify_product_id)
      Rails.logger.info(
        "Received Shopify product response: #{shopify_product.present? ? "present with #{shopify_product['variants']&.size || 0} variants" : 'nil'}"
      )
      shopify_variant = shopify_product['variants'].first

      add_product_to_shopify_collections(product.shopify_product_id)

      Rails.logger.info("Updating Shopify variant variant_id=#{shopify_variant['id']}")
      update_shopify_variant(shopify_variant['id'])

      product.update_columns(shopify_updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
      Rails.logger.info("Synced existing product product_id=#{product.id}")
    end

    def update_shopify_product(product_shopify_id)
      shopify_client
        .put(path: "products/#{product_shopify_id}",
             body: { product: product_shopify_payload }, tries: MAX_RETRIES)
        .body['product']
    end

    def create_new_product # rubocop:disable Metrics/AbcSize
      Rails.logger.info("Creating new Shopify product for product_id=#{product.id}, name=#{product.name}")
      response = shopify_client.post(path: 'products',
                                     body: { product: product_shopify_payload },
                                     tries: MAX_RETRIES)
      shopify_product = response.body['product']
      Rails.logger.info("Received Shopify product creation response: #{shopify_product.present? ? "shopify_product_id=#{shopify_product['id']} with #{shopify_product['variants']&.size || 0} variants" : 'nil'}")
      shopify_variant = shopify_product['variants'].first

      add_product_to_shopify_collections(shopify_product['id'])

      Rails.logger.info("Updating Shopify variant variant_id=#{shopify_variant['id']}")
      update_shopify_variant(shopify_variant['id'])

      product.update_columns(shopify_product_id: shopify_product['id'], # rubocop:disable Rails/SkipsModelValidations
                             shopify_variant_inventory_item_id: shopify_variant['inventory_item_id'],
                             shopify_updated_at: Time.current)
      Rails.logger.info("Created new Shopify product: product_id=#{product.id}, shopify_product_id=#{shopify_product['id']}, inventory_item_id=#{shopify_variant['inventory_item_id']}")
    end

    def update_shopify_variant(variant_id)
      shopify_client.put(path: "variants/#{variant_id}",
                         body: { variant: variant_shopify_payload },
                         tries: MAX_RETRIES)
    end

    def add_product_to_shopify_collections(shopify_product_id) # rubocop:disable Metrics/AbcSize
      Rails.logger.info("Adding product to Shopify collections: shopify_product_id=#{shopify_product_id}")
      add_product_to_shopify_collection(shopify_product_id, product.category.shopify_id) unless product.category&.shopify_id.nil?
      add_product_to_shopify_collection(shopify_product_id, product.manufacturer.shopify_id) unless product.manufacturer&.shopify_id.nil?
      Rails.logger.info('Added product to collections')
    end

    def product_shopify_payload
      {
        title: product.name,
        status: product_shopify_status,
        vendor: product.manufacturer.name,
        product_type: product.category.name,
        tags: product_shopify_tags,
        published_scope: :global,
        published_at: DateTime.now.iso8601,
        images: product_images
      }
    end

    def variant_shopify_payload
      {
        sku: product.manufacturer_sku,
        barcode: product&.sku,
        inventory_management: :shopify,
        price: product.amount_cents.to_i / 100.0
      }
    end

    def product_shopify_tags
      tags = [
        stock_level_tag,
        manufacturer_tag,
        category_hierarchy_tags
      ].flatten.compact.uniq

      Rails.logger.info("Generated Shopify tags for product_id=#{product.id}: #{tags.join(', ')}")
      tags
    end

    def manufacturer_tag
      "manufacturer:#{slugify(product.manufacturer&.name)}" if product.manufacturer&.name.present?
    end

    def stock_level_tag
      product.quantity.positive? ? 'stock:in-stock' : 'stock:out-of-stock'
    end

    def category_hierarchy_tags
      tags = []
      current_category = product.category

      while current_category.present?
        tags << "category:#{slugify(current_category.name)}"
        current_category = current_category.category
      end

      tags
    end

    def slugify(text)
      return nil if text.blank?

      text.parameterize
    end

    def product_shopify_status
      if product.quantity >= 0
        :active
      elsif product.quantity.negative?
        :archived
      else
        :draft
      end
    end

    def product_images
      Rails.logger.info("Processing #{product.images.count} product images for product_id=#{product.id}")
      product.images.map do |image|
        {
          attachment: Base64.strict_encode64(image.download)
        }
      end
    end

    def add_product_to_shopify_collection(product_shopify_id, collection_shopify_id)
      shopify_client.post(path: 'collects',
                          body: { collect: { product_id: product_shopify_id, collection_id: collection_shopify_id } },
                          tries: MAX_RETRIES)
    end
  end
end
