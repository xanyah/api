# frozen_string_literal: true

module Shopify
  class ProductPayloadBuilder
    def initialize(product)
      @product = product
    end

    def product_payload
      {
        title: product.name,
        body_html: product.description,
        status: product_status,
        vendor: product.manufacturer&.name || 'Unknown',
        product_type: product.category&.name || 'Uncategorized',
        tags: Shopify::ProductTagBuilder.new(product).build,
        published_scope: :global,
        published_at: DateTime.now.iso8601,
        images: product_images
      }
    end

    def variant_payload
      {
        sku: product.manufacturer_sku,
        barcode: product&.sku,
        inventory_management: :shopify,
        price: (product.amount_cents || 0) / 100.0
      }
    end

    private

    attr_reader :product

    def product_status
      status = product.quantity.positive? ? :active : :draft
      Rails.logger.info("Setting Shopify status for product_id=#{product.id}: #{status} (quantity=#{product.quantity})")
      status
    end

    def product_images
      Rails.logger.info("Processing #{product.images.count} product images for product_id=#{product.id}")
      product.images.filter_map { |image| process_single_image(image) }
    end

    def process_single_image(image)
      attachment = Base64.strict_encode64(image.download)
      { attachment: attachment }
    rescue StandardError => e
      Rails.logger.error("Failed to process image for product_id=#{product.id}: #{e.message}")
      nil
    end
  end
end
