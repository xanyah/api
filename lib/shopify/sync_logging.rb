# frozen_string_literal: true

module Shopify
  module SyncLogging
    extend ActiveSupport::Concern

    private

    def log_sync_start(product_id)
      Rails.logger.info("Starting Shopify sync for product_id=#{product_id}, store_id=#{@store.id}")
    end

    def log_sync_completion(product_id)
      Rails.logger.info("Completed Shopify sync for product_id=#{product_id}")
    end

    def log_inventory_update_start
      Rails.logger.info(
        "Updating Shopify inventory: product_id=#{product.id}, " \
        "inventory_item_id=#{product.shopify_variant_inventory_item_id}, quantity=#{product.quantity}"
      )
    end

    def log_inventory_update_success
      Rails.logger.info("Successfully updated Shopify inventory for product_id=#{product.id}")
    end

    def log_shopify_product_response(shopify_product)
      response_summary = if shopify_product.present?
                           "shopify_product_id=#{shopify_product['id']} with #{shopify_product['variants']&.size || 0} variants"
                         else
                           'nil'
                         end
      Rails.logger.info("Received Shopify product creation response: #{response_summary}")
    end
  end
end
