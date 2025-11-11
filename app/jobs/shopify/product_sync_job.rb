# frozen_string_literal: true

module Shopify
  class ProductSyncJob < BaseJob # rubocop:disable Metrics/ClassLength
    attr_reader :product

    def perform(product_id)
      @product = Product.find(product_id)
      @shop = @product.store

      if product.shopify_id.present?
        sync_existing_product
      else
        create_new_product
      end
      update_shopify_quantity
    end

    private

    def update_shopify_quantity
      shopify_client.post(path: 'inventory_levels/set',
                          body: {
                            location_id: product.store.shopify_location_id,
                            inventory_item_id: product.shopify_variant_inventory_item_id,
                            available: product.quantity
                          },
                          tries: MAX_RETRIES)
    end

    def sync_existing_product
      shopify_product = update_shopify_product(product.shopify_product_id)
      shopify_variant = shopify_product['variants'].first

      add_product_to_shopify_collections(product.shopify_product_id)

      update_shopify_variant(shopify_variant['id'])

      product.update!(shopify_updated_at: Time.current)
    end

    def update_shopify_product(product_shopify_id)
      shopify_client
        .put(path: "products/#{product_shopify_id}",
             body: { product: product_shopify_payload }, tries: MAX_RETRIES)
        .body['product']
    end

    def create_new_product
      response = shopify_client.post(path: 'products',
                                     body: { product: product_shopify_payload },
                                     tries: MAX_RETRIES)
      shopify_product = response.body['product']
      shopify_variant = shopify_product['variants'].first

      add_product_to_shopify_collections(shopify_product['id'])

      update_shopify_variant(shopify_variant['id'])

      product.update!(shopify_product_id: shopify_product['id'],
                      shopify_variant_inventory_item_id: shopify_variant['inventory_item_id'],
                      shopify_updated_at: Time.current)
    end

    def update_shopify_variant(variant_id)
      shopify_client.put(path: "variants/#{variant_id}",
                         body: { variant: variant_shopify_payload },
                         tries: MAX_RETRIES)
    end

    def add_product_to_shopify_collections(shopify_product_id)
      add_product_to_shopify_collection(shopify_product_id, product.category.shopify_id) unless product.category&.shopify_id.nil?
      add_product_to_shopify_collection(shopify_product_id, product.manufacturer.shopify_id) unless product.manufacturer&.shopify_id.nil?
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
        images: local_images
      }
    end

    def variant_shopify_payload
      {
        sku: product.manufacturer&.code,
        barcode: product.manufacturer&.sku,
        inventory_management: :shopify,
        price: product.amount_cents.to_i / 100.0
      }
    end

    def product_shopify_tags
      [
        product.manufacturer&.name,
        product.category&.name,
        product.category.category&.name
      ].compact
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
